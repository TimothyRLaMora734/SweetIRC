//
//  ChanellBarView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct RoomBarView: View {
    
    @EnvironmentObject var state: ChatState
    
    var body: some View {
        List {
            DisclosureGroup {
                ForEach(state.rooms) { room in
                    NavigationLink(destination: MessageView(), label: {Text("\(room.name)")})
                }
            } label: {
                Label("\(state.severInfo.friendlyName)", systemImage: "server.rack")
            }
        }
    }
}

struct ChanellBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoomBarView()
            .environmentObject(ChatState(selectedServer: servers[0], user: users[0]))
    }
}
