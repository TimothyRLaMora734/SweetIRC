//
//  ChanellBarView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct RoomBarView: View {
    
    @StateObject var state: MessageDispatcher
    
    var body: some View {
        List {
            DisclosureGroup {
                ForEach(state.rooms, id: \.self) { room in
                    NavigationLink(destination: MessageView(room: state.roomOf(name: room.name)), label: {Text("\(room.name)")})
                }
            } label: {
                Label("\(state.serverInfo.friendlyName)", systemImage: "server.rack")
            }
        }
    }
}

struct ChanellBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoomBarView(state: MessageDispatcher(info: servers[0], user: User()))
    }
}
