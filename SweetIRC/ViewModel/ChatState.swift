//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.02.2022.
//

import Foundation
import SwiftUI



class ChatState: ObservableObject {
    
    private let connection: ServerConnection
    
    @Published var rooms: [Room] = []
    
    var focusedRoom: Binding<Room> {
        Binding(get: { self.rooms.first { $0.isFocused == true }! },
                set:  { newRoom in
            let room = self.rooms.first { $0.isFocused == true }!
            let index = self.rooms.firstIndex(of: room)!
            self.rooms[index] = newRoom
        })
    }
    
    var server: Server {
        connection.server
    }
    
    
    init(server: Server, user: User) {
        self.connection = ServerConnection(to: server, with: user)
        
        self.rooms.append(Room(name: "System room for \(server.friendlyName)", server: server, isFocused: true))
    }
    
}
