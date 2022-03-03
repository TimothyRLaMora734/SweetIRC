//
//  Room.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import Foundation

class Room: ObservableObject, Identifiable {
    
    let id = UUID()
    let name: String
    let info: ServerInfo
    
    @Published private(set) var chat = ""
    var isFocused = false
    
    
    func write(message: String) {
        chat += message
    }
    
    convenience init(name: String, info: ServerInfo, isFocused: Bool?){
        self.init(name: name, info: info)
        self.isFocused = isFocused ?? false
    }
    
    init(name: String, info: ServerInfo) {
        self.name = name
        self.info = info
    }
}
