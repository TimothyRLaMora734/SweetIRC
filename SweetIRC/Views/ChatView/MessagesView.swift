//
//  MessagesView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 15.02.2022.
//

import SwiftUI

struct MessagesView: View {
    
    @EnvironmentObject private var chatState: ChatState
    
    var body: some View {
            TextEditor(text: chatState.chat)
            .frame(width: 640)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
