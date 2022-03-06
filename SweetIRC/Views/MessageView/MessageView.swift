//
//  MessagesView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct MessageView: View {
    
    @StateObject var room: Room
        
    var body: some View {
        VStack{
            MessageTextAreaView(room: room)
                .frame(minHeight: 520)
            MessageSendView(currentRoom: room)
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(room: rooms[0])
    }
}
