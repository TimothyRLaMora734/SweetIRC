//
//  ChatView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject private var chatState: ChatState
    
    
    var body: some View {
        NavigationView{
            RoomBarView()
                .frame(minWidth: 150)
            MessagesView()
        }
        .frame(width: 800, height: 600)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatState())
    }
}
