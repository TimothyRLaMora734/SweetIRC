//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class IRCServer {
    static let timeOut = 10.0, maxRead = 220, minRead = 1
    
    let info: ServerInfo
    
    private let connectionTask: URLSessionStreamTask
    
    init(of info: ServerInfo)  {
        print("Connecting to \(info.hostname):\(info.port)....")
        self.info = info
        self.connectionTask = URLSession.shared.streamTask(withHostName: info.hostname, port: info.port)
        self.connectionTask.startSecureConnection()
        self.connectionTask.resume()
    }
    
    
    private func send(command: String) async throws  {
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw ServerConnectionError.BadEncoding
        }
        
        try await connectionTask.write(data, timeout: IRCServer.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    private func messageStream() -> AsyncStream<String> {
        AsyncStream<String> {  continuation  in
            Task {
                await receiveMessage()
            }
            
            @Sendable func receiveMessage() async  {
                guard let (data, isDone) = try? await self.connectionTask.readData(ofMinLength: IRCServer.minRead, maxLength: IRCServer.maxRead, timeout: IRCServer.timeOut) else {
                    return continuation.finish()
                }
                
                guard let data = data else {
                    return  continuation.finish()
                }
                
                guard let message = String(data: data, encoding: .utf8) else {
                    return continuation.finish()
                }
                
                if isDone {
                    return continuation.finish()
                }
                
                print("Received from server: \(message)")
                continuation.yield(message)
                await receiveMessage()
            }
        }
    }
    
    public func connect(as user: User) async throws -> Room {
        try await  self.send(command: "NICK \(user.nickName)")
        try await  self.send(command: "USER \(user.userName) 0 * :\(user.realName)")
        
        
        let room = Room(name: "systemRoom", server: self)
        Task.detached(priority: .background) {
            for await message in server.messageStream() {
                if message.contains("libera.chat"){
                    room.receiveMessage(of: message)
                }
            }
        }
        return room
        
    }
    
    public func sendMessage(_ message: String, to roomName: String) {
        Task {
            try await self.send(command: "PRIVMSG \(roomName) :\(message)")
        }
    }
    
    public func joinRoom(of roomName: String) -> Room {
        Task {
            try await self.send(command: "JOIN \(roomName)")
        }
        let newRoom = Room(name: roomName, server: self)
        Task.detached(priority: .background) {
            for await message in server.messageStream() {
                if message.contains("PRIVMSG \(newRoom.name)") {
                    DispatchQueue.main.async {
                        newRoom.receiveMessage(of: message)
                    }
                }
            }
        }
        return newRoom
    }
}



enum ServerConnectionError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
