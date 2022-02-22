//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class ServerConnection {
    static let timeOut = 10.0
    
    static let maxRead = 220
    
    let server: Server
    
    let connectionTask: URLSessionStreamTask
    
    
    init(to server: Server, with user: User)  {
        print("Connecting to \(server.hostname):\(server.port)....")
        self.server = server
        self.connectionTask = URLSession.shared.streamTask(withHostName: server.hostname, port: server.port)
        self.connectionTask.startSecureConnection()
        self.connectionTask.resume()
        
        
        Task {
            do {
                try await  send(command: "PASS \(user.password)")
                try await  send(command: "NICK \(user.nickName)")
                try await  send(command: "USER \(user.userName) 0 * :\(user.realName)")
            } catch  {
                print("Could not connect to \(server.friendlyName)")
            }
        }
    }
    
    
    
    
    func send(command: String) async throws  {
        
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw InvalidDataError.BadEncoding
        }
        
        try await connectionTask.write(data, timeout: ServerConnection.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    func receive() async -> String {
        guard let (data,isDone) = try? await connectionTask.readData(ofMinLength: 1, maxLength: ServerConnection.maxRead, timeout: ServerConnection.timeOut) else {
            return ""
        }
        
        guard let data = data else {
            return ""
        }
        
        guard var message = String(data: data, encoding: .utf8) else {
            return ""
        }
        
        if !isDone {
            message +=  await receive()
        }
        print("Received from server: \(message)")
        return message
    }
}



enum InvalidDataError : Error {
    case NoData
    case BadEncoding
}
