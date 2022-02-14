//
//  LoginView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 50) {
            Text("Sweet IRC ")
                .font(.title)
                .padding(.top)
            
            LoginFormView(user: $viewModel.user)
            
            Button(action: {
                
            }) {
                Text("Connect")
                    .font(.system(size: 15))
                    .frame(width: 80, height: 30)
            }
            Spacer()
        }
        .frame(width: 300, height: 400)

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
