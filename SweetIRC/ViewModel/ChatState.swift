//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 03.03.2022.
//

import SwiftUI

class ChatState: ObservableObject {
    public let server: IRCServer
    
    @Published private(set) var isConnected = false
    
    @Published private(set) var rooms: [Room] = []
    
    init(server: IRCServer) {
        self.server = server
    }
    
    public func joinRoom(named name: String) {
       let room = server.joinRoom(of: name)
        rooms.append(room)
    }
    
    public var serverInfo: ServerInfo {
        server.info
    }
}
