//
//  ChanellBarView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct RoomBarView: View {
    
    @EnvironmentObject var server: IRCServer
    
    var body: some View {
        List {
            DisclosureGroup {
                ForEach(server.rooms) { room in
                    NavigationLink(destination: MessageView(room: room), label: {Text("\(room.name)")})
                }
            } label: {
                Label("\(server.info.friendlyName)", systemImage: "server.rack")
            }
        }
    }
}

struct ChanellBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoomBarView()
            .environmentObject(server)
    }
}
