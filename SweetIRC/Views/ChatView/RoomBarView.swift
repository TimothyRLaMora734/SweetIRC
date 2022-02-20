//
//  ChanellBarView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct RoomBarView: View {
    
    @EnvironmentObject private var chatState: ChatState
    
    var body: some View {
        List {
            ForEach(chatState.rooms, id: \.self) { room in
                Text("\(room.name)")
                    .padding(.top)
            }
        }
    }
}

struct ChanellBarView_Previews: PreviewProvider {
    static var previews: some View {
        RoomBarView()
            .environmentObject(ChatState())
    }
}
