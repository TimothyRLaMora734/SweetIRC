//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 03.03.2022.
//

import SwiftUI

class ChatState: ObservableObject {
    private let server: IRCServer
    
    @Published private(set) var isConnected = false
    
    @Published private(set) var rooms: [Room] = []
    
    init(server: IRCServer, of user: User) {
        self.server = server
        Task.detached(priority: .background) {
            let result = try await server.connect(as: user)
            DispatchQueue.main.async {
                self.isConnected = true
                self.rooms.append(result)
            }
        }
    }
    
    public func joinRoom(named name: String) {
       let room = server.joinRoom(of: name)
        rooms.append(room)
    }
    
    public var serverInfo: ServerInfo {
        server.info
    }
}
