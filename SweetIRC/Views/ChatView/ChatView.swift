//
//  ChatView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var state: ChatState
    
    
    var body: some View {
        NavigationView{
            RoomBarView()
                .frame(minWidth: 150)
            Group{
                
            }
        }
        .frame(width: 800, height: 600)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatState(server: IRCServer(of: servers[0]), of: users[0]))
    }
}
