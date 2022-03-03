//
//  ChatState.swift
//  SweetIRC
//
//  Created by Dan Stoian on 22.02.2022.
//

import Foundation
import SwiftUI



class MessageDispatcher {
    private var subscribers: [String:Room] = [:]
    
    private var listeningForMessagesTask: Task<Void,Error>!
    
    
    func subscribe(room: Room) {
        subscribers[room.name] = room
    }
    
    func unsubscribe(room: Room) {
        subscribers[room.name] = nil
    }
    
    
    func startDispatching(from server: IRCServer) {
        if let task = self.listeningForMessagesTask {
            task.cancel()
        }
        
        self.listeningForMessagesTask = Task.detached(priority: .background) {
            for await message in server.messageStream() {
                DispatchQueue.main.async {
                    let (roomName, message) = self.pasrseMessage(message: message)
                    if let room = self.subscribers[roomName] {
                        room.write(message: message)
                    } else {
                        self.subscribers["systemRoom"]!.write(message: message)
                    }
                }
            }
        }
    }
    
    private func pasrseMessage(message: String) -> (String, String) {
        guard let firstSpaceIndex = message.firstIndex(of: " ") else {
            return ("systemRoom", message)
        }
        let roomName = message[..<firstSpaceIndex]
        let message = message[firstSpaceIndex...]
        
        return ( String(roomName), String(message))
    }
    
}
