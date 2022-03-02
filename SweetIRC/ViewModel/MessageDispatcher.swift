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
    
    @Published private(set)  var isConnected: Bool = false {
        willSet{
            if newValue {
                self.startDispatching()
            }
        }
    }
    
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
        Task.detached {
            let result = try await connect(to: self.server, as: user)
            DispatchQueue.main.async {
                self.isConnected = result
            }
        }
    }
    
    
    func startDispatching() {
        if let task = self.listeningForMessagesTask {
            task.cancel()
        }
        
        self.listeningForMessagesTask = Task.detached(priority: .background) {
            for await message in self.server.messageStream() {
                DispatchQueue.main.async {
                    self.rooms[0].write(message: message)
                }
            }
            return true
        }
    }
    
}
