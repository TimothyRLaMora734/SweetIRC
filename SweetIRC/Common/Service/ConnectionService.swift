//
//  ConnectionService.swift
//  SweetIRC
//
//  Created by Dan Stoian on 18.02.2022.
//

import Foundation



class ConnectionService {
    
    let timeOut = 10.0
    
    let server: Server
    
    let connectionTask: URLSessionStreamTask
    
    init(to server: Server, using user: User) {
        print("Connecting to \(server.hostname):\(server.port)....")
        self.server = server
        self.connectionTask = URLSession.shared.streamTask(withHostName: server.hostname, port: server.port)
        self.connectionTask.resume()
        
        
        self.send(command: "PASS \(user.password)")
        self.send(command: "NICK \(user.nickName)")
        self.send(command: "USER \(user.userName) 0 * :\(user.realName)")
        
        self.receive()
    }
    
    
    
    
    func send(command: String) {
        connectionTask.write((command + "\r\n").data(using: .utf8)!, timeout: timeOut) { err in
            if let err = err {
                print("Could not send data to \(self.server.friendlyName), reason: \(err.localizedDescription)")
            }
            print("Command \(command) was sent succesfully!")
        }
    }
    
    
    func receive() {
        connectionTask.readData(ofMinLength: 1, maxLength: 200, timeout: timeOut) { data, isDone, err in
            
            guard err == nil else {
                print("Encuntered error at receiving data: \(err!.localizedDescription)")
                return
            }
            
            guard let data = data, let message = String(data: data, encoding: .utf8) else {
                return
            }

            
            if isDone == false {
                print("Reveiced from the server: \(message)")
                self.receive()
            }
        }
    }
}
