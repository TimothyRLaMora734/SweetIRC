//
//  MessagesView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct MessagesView: View {
    
    @Binding var room: Room
    
    var body: some View {
        TextEditor(text: $room.chat)
            .frame(width: 640)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(room: .constant(Room(name: "System Room", server: servers[0], isFocused: true)))
    }
}
