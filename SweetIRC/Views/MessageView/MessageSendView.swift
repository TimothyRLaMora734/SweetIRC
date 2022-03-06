//
//  MessageSendView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 23.02.2022.
//

import SwiftUI

struct MessageSendView: View {
    
    let currentRoom: Room?
    
    @EnvironmentObject var state: ChatState
    @State private var textEntry = ""
    
    var body: some View {
        HStack {
            TextField("", text: $textEntry, prompt: Text("Send message here..."))
            Button(action: {
                state.joinRoom(named: textEntry)
            }, label: {
                Text("Send")
            })
        }
        .padding()
    }
}

struct MessageSendView_Previews: PreviewProvider {
    static var previews: some View {
        MessageSendView(currentRoom: rooms[0])
    }
}
