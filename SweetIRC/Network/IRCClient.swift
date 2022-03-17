//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class IRCClient: ObservableObject {
    static let timeOut = 0.0, maxRead = 512, minRead = 1
    
    let info: ServerInfo
    
    private let connectionTask: URLSessionStreamTask
    
    @Published private(set) var rooms: [Room] = []
    
    @Published private(set) var channels: [String] = []
    
    
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
    
    public func listChannels() {
        Task.detached(priority: .background) {
            try await self.send(command: "LIST")
        }
    }
    
    private func sendPong(pingMessage: String) {
        Task.detached(priority: .background) {
            try await self.send(command: "PONG")
        }
    }
    
    private func send(command: String) async throws  {
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw ServerConnectionError.BadEncoding
        }
        
        try await connectionTask.write(data, timeout: IRCClient.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    private func messageStream() -> AsyncStream<String> {
        AsyncStream<String> {  continuation  in
            Task {
                let _ = await receiveMessage()
                print("End of data stream")
            }
            
            @Sendable func receiveMessage(buufer: String = "") async -> String  {
                guard let (data, isDone) = try? await self.connectionTask.readData(ofMinLength: IRCClient.minRead, maxLength: IRCClient.maxRead, timeout: IRCClient.timeOut) else {
                    continuation.finish()
                    return ""
                }
                
                guard let data = data else {
                    continuation.finish()
                    return ""
                }
                
                guard var message = String(data: data, encoding: .utf8) else {
                    continuation.finish()
                    return ""
                }
                
                if isDone {
                    continuation.finish()
                    return ""
                }
                
                print("Received from server: \(message)")
                if !message.contains("\n") {
                    message += await receiveMessage()
                }
                continuation.yield(message)
                return await receiveMessage()
            }
        }
    }
    
    private func dispatch() {
        Task.detached(priority: .background) {
            for await message in self.messageStream() {
                dispatchToRoom(message)
            }
        }
        
        @Sendable func dispatchToRoom(_ message: String) {
            switch message {
            case let message where message.contains("QUIT :Ping"):
                self.sendPong(pingMessage: message)
                return
            case let message where message.contains("PRIVMSG "):
                let split = message.split(separator: " ")
                let roomName = split[2]
                let personName = split[0]
                let lasC = message.lastIndex(of: ":")!
                let message = String(message[message.index(after: lasC)...])
                self.rooms.first(where: { $0.name == roomName})!.receiveMessage(of: message, from: String(personName[personName.index(after: personName.startIndex)...personName.index(before: personName.firstIndex(of: "@")!)]))
            case let message where message.contains("322"):
                let split = message.split(separator: " ")
                let st = split[3].startIndex
                let end = split[3].endIndex
                DispatchQueue.main.async {
                    self.channels.append(String(message[st...end]))
                }
            default:
                let idx = message.firstIndex(of: " ")!
                self.rooms[0].receiveMessage(of: String(message[idx...]), from: String(message[...idx]))
            }
        }
    }
}



enum ServerConnectionError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
