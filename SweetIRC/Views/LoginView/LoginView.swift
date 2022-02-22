//
//  LoginView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var state: LoginState
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Sweet IRC ")
                .font(.title)
                .padding(.top)
            
            LoginFormView(state: state)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 1.5)) {
                    state.isLoginDone.toggle()
                }
            }) {
                Text("Connect")
                    .font(.system(size: 15))
                    .frame(width: 80, height: 30)
                    .scaleEffect(state.isLoginDone ? 1.5 : 1.0)

            }
            .disabled(!state.canLogin())
            Spacer()
        }
        .frame(width: 300, height: 400)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(state: LoginState())
    }
}
