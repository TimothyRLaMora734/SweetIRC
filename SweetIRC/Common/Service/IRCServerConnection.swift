//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class IRCServerConnection {
    static let timeOut = 10.0
    
    static let maxRead = 220
    
    let server: Server
    
    let connectionTask: URLSessionStreamTask
    
    
    init(to server: Server)  {
        print("Connecting to \(server.hostname):\(server.port)....")
        self.server = server
        self.connectionTask = URLSession.shared.streamTask(withHostName: server.hostname, port: server.port)
        self.connectionTask.startSecureConnection()
        self.connectionTask.resume()
    }
    
    
    
    
    func send(command: String) async throws  {
        let command  = command + "\n"
        
        guard let data = command.data(using: .utf8) else {
            throw InvalidDataError.BadEncoding
        }
        
        try await connectionTask.write(data, timeout: IRCServerConnection.timeOut)
        print("Sent to server: \(command)")
    }
    
    
    func receive() async throws -> (String, Bool)  {
        guard let (data,isDone) = try? await connectionTask.readData(ofMinLength: 1, maxLength: IRCServerConnection.maxRead, timeout: IRCServerConnection.timeOut) else {
            throw InvalidDataError.BadServer
        }
        
        guard let data = data else {
            throw InvalidDataError.NoData
        }
        
        guard let message = String(data: data, encoding: .utf8) else {
            throw InvalidDataError.BadEncoding
        }
        
        print("Received from server: \(message)")
        return (message, isDone)
    }
}



enum InvalidDataError : Error {
    case NoData
    case BadEncoding
    case BadServer
}
