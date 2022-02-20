//
//  Room.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import Foundation


struct Room : Hashable {
    let name: String
    let server: String
    
    var chat = ""
    var isFocused = false
}
