//
//  LoginView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var chatState: ChatState
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Sweet IRC ")
                .font(.title)
                .padding(.top)
            
            LoginFormView(user: $chatState.user)
            
            Button(action: {
                withAnimation {
                    chatState.isLoginDone.toggle()
                }
            }) {
                Text("Connect")
                    .font(.system(size: 15))
                    .frame(width: 80, height: 30)
                    .scaleEffect(chatState.isLoginDone ? 1.5 : 1.0)

            }
            .disabled(!chatState.user.canLogin())
            Spacer()
        }
        .frame(width: 300, height: 400)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(chatState: ChatState())
    }
}
