//
//  ChatView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView{
            Text("Sidebar")
                .frame(minWidth: 150)
            Text("Chat")
        }
            .frame(width: 800, height: 600)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
