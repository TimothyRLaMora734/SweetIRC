//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.02.2022.
//

import Foundation
import SwiftUI



class MessageDispatcher: ObservableObject {
    
    private let connection: IRCServerConnection
    
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
        self.connection = IRCServerConnection(to: server)
        let systemRoom = Room(name: "System room for \(server.friendlyName)", server: server, isFocused: true)
        self.rooms.append(systemRoom)
        self.connect(as: user)
    }
    
    func connect(as user: User) {
        Task {
            do {
                try await  connection.send(command: "PASS \(user.password)")
                try await  connection.send(command: "NICK \(user.nickName)")
                try await  connection.send(command: "USER \(user.userName) 0 * :\(user.realName)")
                listenForMessages()
            } catch  {
                print("Could not connect to \(server.friendlyName)")
            }
        }
    }
    
    func listenForMessages() {
        Task.detached(priority: .background) {
            var isDone = false
            repeat {
                let (message, done) = try await self.connection.receive()
                isDone = done
                DispatchQueue.main.async {
                    self.rooms[0].chat += message
                }

                Thread.sleep(forTimeInterval: 2)
            } while !isDone
        }
    }
    
}
