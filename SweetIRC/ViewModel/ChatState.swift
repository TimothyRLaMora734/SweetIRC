//
//  LoginViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation
import SwiftUI


class ChatState: ObservableObject {
    
    @Published var user = User()
    
    @Published var isLoginDone = false
    
    private var connection: ConnectionService?
    
    private(set) var rooms: [Room] = []
    
    
    var focusedRoom: Room? {
        rooms.first { $0.isFocused == true}
    }
    
    var chat: Binding<String> {
        Binding(get: {
            self.focusedRoom?.chat ?? ""
        }, set: {
            if var room = self.focusedRoom {
                room.chat += $0
            }
        })
    }
    
    func connect() {
        if let server = user.selectedIRCServer {
            self.connection = ConnectionService(to: server, using: user)
        }
    }
    
}
