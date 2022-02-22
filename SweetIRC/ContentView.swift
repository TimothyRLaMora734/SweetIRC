//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    let state = LoginState()
        
    var body: some View {
        if state.isLoginDone {
            ChatView(state: ChatState(server: state.selectedIRCServer!, user: state.user))
                .transition(.slide)
                
        } else {
            LoginView(state: state)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
