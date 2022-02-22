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
    
    
    func roomOf(name: String) -> Binding<Room> {
        Binding(get: {self.rooms.first { $0.name == name}!},
                set: { newRoom in
            let room = self.rooms.first { $0.name == newRoom.name }!
            let index = self.rooms.firstIndex(of: room)!
            self.rooms[index] = newRoom
        })
    }
    
    
    init(server: Server, user: User)  {
        self.connection = ServerConnection(to: server, with: user)
        let systemRoom = Room(name: "System room for \(server.friendlyName)", server: server, isFocused: true)
        self.rooms.append(systemRoom)

        
        Task {
            let message = await connection.receive()
            DispatchQueue.main.async {
                self.rooms[0].chat += message
            }
        }
    }
    
}
