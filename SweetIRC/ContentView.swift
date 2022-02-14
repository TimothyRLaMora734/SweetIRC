//
//  ContentView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        if viewModel.isLoginDone {
            ChatView()
                .transition(.slide)
        } else {
            LoginView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
