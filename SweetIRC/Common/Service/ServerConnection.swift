//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



struct ServerConnection {
    static let timeOut = 10.0
    
    static let maxRead = 220
    
    let server: Server
    
    let user: User
    
    let serverStream: URLSessionStreamTask
        
    private var connectionTask: Task<Bool, Error>?
    
    var isConnected: Bool {
        get async {
            guard
                let task = connectionTask,
                let result = try? await task.value else {
                return false
            }
            return result
        }
    }
        
    init(to server: Server, with user: User) {
        self.server = server
        self.user = user
        
        self.serverStream = URLSession.shared.streamTask(withHostName: server.hostname, port: server.port)
        self.serverStream.startSecureConnection()
        self.serverStream.resume()
        
        self.connectionTask = connect()
    }
    
    
     func connect() -> Task<Bool,Error> {
        print("Connecting to \(server.hostname):\(server.port)....")
        return Task.detached { () -> Bool in
            do {
                try await  send(command: "PASS \(user.password)")
                try await  send(command: "NICK \(user.nickName)")
                try await  send(command: "USER \(user.userName) 0 * :\(user.realName)")
                print("Done conecting to \(server.hostname):\(server.port)....")
            } catch {
                return false
            }
            return true
        }
    }
    
    func send(command: String) async throws  {
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw InvalidDataError.BadEncoding
        }
        
        try await serverStream.write(data, timeout: ServerConnection.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    func receive() async throws -> String{
        let (data,isDone) = try await serverStream.readData(ofMinLength: 1, maxLength: ServerConnection.maxRead, timeout: ServerConnection.timeOut)
        
        guard let data = data else {
            throw InvalidDataError.NoData
        }
        
        guard var message = String(data: data, encoding: .utf8) else {
            throw InvalidDataError.BadEncoding
        }
        
        print("Received from server: \(message)")
        
        if !isDone {
            message += try await receive()
        }
        return message
    }
}



enum InvalidDataError : Error {
    case NoData
    case BadEncoding
}
