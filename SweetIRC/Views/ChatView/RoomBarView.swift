//
//  ChanellBarView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct RoomBarView: View {
    
    @StateObject var state: ChatState
    
    var body: some View {
        List {
            DisclosureGroup {
                ForEach(state.rooms, id: \.self) { room in
                    NavigationLink(destination: MessageView(room: state.roomOf(name: room.name)), label: {Text("\(room.name)")})
                }
            } label: {
                Label("\(state.server.friendlyName)", systemImage: "server.rack")
            }
        }
    }
}

struct ChanellBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoomBarView(state: ChatState(server: servers[0], user: User()))
    }
}
