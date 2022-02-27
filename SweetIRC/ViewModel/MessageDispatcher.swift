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
    
    private var listeningForMessagesTask: Task<Void,Error>!
    
    private var connectingToIRCServerTask: Task<Bool,Never>!
    
    @Published var rooms: [Room] = []
    
    var focusedRoom: Binding<Room> {
        Binding(get: { self.rooms.first { $0.isFocused == true }! },
                set:  { newRoom in
            let room = self.rooms.first { $0.isFocused == true }!
            let index = self.rooms.firstIndex(of: room)!
            self.rooms[index] = newRoom
        })
    }
    
    var server: ServerInfo {
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
    
    
    init(server: ServerInfo, user: User)  {
        self.connection = IRCServerConnection(to: server)
        let systemRoom = Room(name: "System room for \(server.friendlyName)", server: server, isFocused: true)
        self.rooms.append(systemRoom)
        self.connect(as: user)
    }
    
    func connect(as user: User) {
        self.connectingToIRCServerTask = Task.detached {
            do {
                try await  self.connection.send(command: "PASS \(user.password)")
                try await  self.connection.send(command: "NICK \(user.nickName)")
                try await  self.connection.send(command: "USER \(user.userName) 0 * :\(user.realName)")
                self.listenForMessages()
                return true
            } catch  {
                print("Could not connect to \(self.server.friendlyName)")
                return false
            }
        }
    }
    
    func listenForMessages() {
        self.listeningForMessagesTask = Task.detached(priority: .background) {
            var isDone = false
            repeat {
                guard let (message, done) = try? await self.connection.receive() else {
                    throw InvalidDataError.BadServer
                }
                isDone = done
                DispatchQueue.main.async {
                    self.rooms[0].chat += message
                }

            } while !isDone
            print("Done listening!")
        }
    }
    
}
