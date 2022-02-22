//
//  MessageSendView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 23.02.2022.
//

import SwiftUI

struct MessageSendView: View {
    
    let onSend: (String) -> Void
    
    @State private var textEntry = ""
    
    var body: some View {
        HStack {
            TextField("", text: $textEntry, prompt: Text("Send message here..."))
            Button(action: {
                onSend(textEntry)
            }, label: {
                Text("Send")
            })
        }
        .frame(height: 50)
    }
}

struct MessageSendView_Previews: PreviewProvider {
    static var previews: some View {
        MessageSendView(onSend: { t in })
    }
}
