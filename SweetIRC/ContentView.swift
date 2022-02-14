//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var chatState: ChatState
    
    var body: some View {
        if chatState.isLoginDone {
            ChatView()
                .transition(.slide)
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ChatState())
    }
}
