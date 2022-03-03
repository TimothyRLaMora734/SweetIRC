//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 03.03.2022.
//

import Foundation
import SwiftUI


class ChatState: ObservableObject {
   
   private let dispatcher = MessageDispatcher()
    
   private let user: User
        
   private let server: IRCServer
    
    
    var focusedRoom: Room {
        rooms.first { $0.isFocused }!
    }
    
    var severInfo: ServerInfo {
        server.info
    }
    
    @Published private(set) var rooms: [Room] = []
    
    
    init(selectedServer: ServerInfo, user: User) {
        self.user = user
        self.server = IRCServer(of: selectedServer)
        
        let systemRoom = Room(name: "systemRoom", info: selectedServer, isFocused: true)
        dispatcher.subscribe(room: systemRoom)
        rooms.append(systemRoom)
        dispatcher.startDispatching(from: self.server)
        self.connect()
    }
    
    func connect() {
        Task.detached(priority: .background) {
            try await connectToIRCServer(of: self.server, as: self.user)
        }
    }
    
   
}
