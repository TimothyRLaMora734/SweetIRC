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
        Text(room.chat)
            .lineLimit(nil)
    }
}

struct MessageTextArea_Previews: PreviewProvider {
    static var previews: some View {
        return MessageTextAreaView(room: rooms[0])
    }
}
