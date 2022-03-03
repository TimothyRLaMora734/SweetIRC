//
//  MessagesView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct MessageView: View {
    
    @EnvironmentObject var state: ChatState
        
    var body: some View {
        VStack{
            MessageTextAreaView(room: state.focusedRoom)
                .frame(minHeight: 300)
            MessageSendView(onSend: { text in state.focusedRoom.write(message:text)})
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
            .environmentObject(ChatState(selectedServer: servers[0], user: users[0]))
    }
}
