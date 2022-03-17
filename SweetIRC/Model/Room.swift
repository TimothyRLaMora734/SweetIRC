//
//  Room.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import Foundation

class Room: ObservableObject, Identifiable {
    let id = UUID()
    let name: String
    private let server: IRCClient
    
    @Published private(set) var chat = ""
    
    
    public func receiveMessage(of message: String, from name: String ) {
        DispatchQueue.main.async {
            self.chat += "\(name): \(message)"
        }
    }
    
    public func sendMessage(_ message: String) {
        server.sendMessage(message, to: self.name)
    }
    
    init(name: String, server: IRCClient){
        self.name = name
        self.server = server
    }
}
