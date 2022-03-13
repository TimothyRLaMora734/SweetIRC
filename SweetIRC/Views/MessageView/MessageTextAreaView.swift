//
//  MessageTextArea.swift
//  SweetIRC
//
//  Created by Dan Stoian on 23.02.2022.
//

import SwiftUI

struct MessageTextAreaView: View {

    @ObservedObject var room: Room
    
    var body: some View {
        GeometryReader { proxy in
            Text(room.chat)
                .lineLimit(nil)
        }
        .frame(minHeight: 520)
    }
}

struct MessageTextArea_Previews: PreviewProvider {
    static var previews: some View {
        return MessageTextAreaView(room: rooms[0])
    }
}
