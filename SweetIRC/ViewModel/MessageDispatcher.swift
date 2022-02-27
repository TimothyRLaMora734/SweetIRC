//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.02.2022.
//

import Foundation
import SwiftUI



class MessageDispatcher: ObservableObject {
    
    private let server: IRCServer
    
    private var listeningForMessagesTask: Task<Bool,Error>!
    
    private var connectingToIRCServerTask: Task<Bool,Never>!
    
    let serverInfo: ServerInfo
    
    @Published var rooms: [Room] = []
    
    var focusedRoom: Binding<Room> {
        Binding(get: { self.rooms.first { $0.isFocused == true }! },
                set:  { newRoom in
            let room = self.rooms.first { $0.isFocused == true }!
            let index = self.rooms.firstIndex(of: room)!
            self.rooms[index] = newRoom
        })
    }
    
    
    
    func roomOf(name: String) -> Binding<Room> {
        Binding(get: {self.rooms.first { $0.name == name}!},
                set: { newRoom in
            let room = self.rooms.first { $0.name == newRoom.name }!
            let index = self.rooms.firstIndex(of: room)!
            self.rooms[index] = newRoom
        })
    }
    
    
    init(info: ServerInfo, user: User)  {
        self.serverInfo = info
        self.server = IRCServer(of: info)
        let systemRoom = Room(name: "System room for \(info.friendlyName)", info: info, isFocused: true)
        self.rooms.append(systemRoom)
        self.connectingToIRCServerTask = connect(to: server, as: user)
        self.listeningForMessagesTask = server.startReceivingMessage(to: self)
    }
    
    
    func dispatch(message: String) {
        DispatchQueue.main.async {
            self.rooms[0].write(message: message)
        }
    }
    
}
