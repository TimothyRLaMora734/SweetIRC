//
//  Room.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import Foundation


struct Room : Hashable {
    let name: String
    let server: ServerInfo
    
    var chat = ""
    var isFocused = false
    
    
    mutating func write(message: String) {
        chat += message
    }
}
