//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class IRCServer {
    static let timeOut = 10.0
    
    static let maxRead = 220
    
    let info: ServerInfo
    
    let connectionTask: URLSessionStreamTask
    
    
    init(of info: ServerInfo)  {
        print("Connecting to \(info.hostname):\(info.port)....")
        self.info = info
        self.connectionTask = URLSession.shared.streamTask(withHostName: info.hostname, port: info.port)
        self.connectionTask.startSecureConnection()
        self.connectionTask.resume()
    }
    
    
    
    
    fileprivate func send(command: String) async throws  {
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw ServerConnectionError.BadEncoding
        }
        
        try await connectionTask.write(data, timeout: IRCServer.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    func startReceivingMessage(to dispatcher: MessageDispatcher) -> Task<Bool,Error> {
        Task.detached(priority: .background) { () throws -> Bool in
            var isDone = false
            
            repeat {
                guard let (data, done) = try? await self.connectionTask.readData(ofMinLength: 1, maxLength: IRCServer.maxRead, timeout: IRCServer.timeOut) else {
                    throw ServerConnectionError.BadServer
                }
                
                guard let data = data else {
                    throw ServerConnectionError.NoData
                }
                
                guard let message = String(data: data, encoding: .utf8) else {
                    throw ServerConnectionError.BadEncoding
                }
                
                print("Received from server: \(message)")
                dispatcher.dispatch(message: message)
                isDone = done
            } while !isDone
            return true
        }
    }
}


func connect(to server: IRCServer, as user: User) -> Task<Bool,Never> {
    Task.detached {
        do {
            try await  server.send(command: "PASS \(user.password)")
            try await  server.send(command: "NICK \(user.nickName)")
            try await  server.send(command: "USER \(user.userName) 0 * :\(user.realName)")
            print("Done connecting to: \(server.info.friendlyName)")
            return true
        } catch  {
            print("Could not connect to \(server.info.friendlyName)")
            return false
        }
    }
    
}


enum ServerConnectionError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
