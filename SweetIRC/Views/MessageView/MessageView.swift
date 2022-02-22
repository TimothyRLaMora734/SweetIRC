//
//  MessagesView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct MessageView: View {
    
    @Binding var room: Room
    
    var body: some View {
        VStack{
            MessageTextAreaView(text: $room.chat)
            MessageSendView(onSend: { text in  room.chat += text })
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(room: .constant(Room(name: "System Room", server: servers[0], isFocused: true)))
    }
}
