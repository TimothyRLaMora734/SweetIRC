//
//  ChatView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var state: ChatState
    
    
    var body: some View {
        NavigationView{
            RoomBarView(state: state)
                .frame(minWidth: 150)
            MessagesView(room: state.focusedRoom)
        }
        .frame(width: 800, height: 600)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(state: ChatState(server: servers[0], user: User(userName: "Dan", nickName: "dan01", realName: "Dan Me", password: "Alibaba")))
    }
}
