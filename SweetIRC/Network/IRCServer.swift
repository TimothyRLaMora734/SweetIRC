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
    
    static let minRead = 1
    
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
    
    
    func messageStream() -> AsyncStream<String> {
        AsyncStream<String> {  continuation  in
            Task {
                await receiveMessage()
            }
        }
        
        func receiveMessage() async  {
            guard let (data, isDone) = try? await self.connectionTask.readData(ofMinLength: IRCServer.minRead, maxLength: IRCServer.maxRead, timeout: IRCServer.timeOut) else {
                return continuation.finish()
            }

            guard let data = data else {
               return  continuation.finish()
            }

            guard let message = String(data: data, encoding: .utf8) else {
                return continuation.finish()
            }

            if !isDone {
                continuation.yield(message)
                await receiveMessage()
            } else {
                return continuation.finish()
            }
        }
    }
}


func connect(to server: IRCServer, as user: User) async throws -> Bool {
    try await  server.send(command: "PASS \(user.password)")
    try await  server.send(command: "NICK \(user.nickName)")
    try await  server.send(command: "USER \(user.userName) 0 * :\(user.realName)")
    return true
}


enum ServerConnectionError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
