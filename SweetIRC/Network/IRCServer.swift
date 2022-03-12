//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class IRCServer: ObservableObject {
    static let timeOut = 0.0, maxRead = 512, minRead = 1
    
    let info: ServerInfo
    
    private let connectionTask: URLSessionStreamTask
    
    @Published private(set) var rooms: [Room] = []
    
    init(of info: ServerInfo, as user: User)  {
        print("Connecting to \(info.hostname):\(info.port)....")
        self.info = info
        self.connectionTask = URLSession.shared.streamTask(withHostName: info.hostname, port: info.port)
        self.connectionTask.startSecureConnection()
        self.connectionTask.resume()
        
        connect(as: user)
        rooms.append(Room(name: info.domain, server: self))
        dispatch()
    }
    
    private func connect(as user: User) {
        Task.detached(priority: .background) {
            try await  self.send(command: "NICK \(user.nickName)")
            try await  self.send(command: "USER \(user.userName) 0 * :\(user.realName)")
        }
    }
    
    public func sendMessage(_ message: String, to roomName: String) {
        Task {
            try await self.send(command: "PRIVMSG \(roomName) :\(message)")
        }
    }
    
    public func joinRoom(of roomName: String) {
        let newRoom = Room(name: roomName, server: self)
        rooms.append(newRoom)
        Task.detached(priority: .background) {
           try await self.send(command: "JOIN \(roomName)")
        }
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
                print("End of data stream")
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
    
    private func dispatch() {
        Task.detached(priority: .background) {
            for await message in self.messageStream() {
                self.rooms[0].receiveMessage(of: message)
            }
        }
    }
}



enum ServerConnectionError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
