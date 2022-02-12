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
        VStack {
            Text("Welcome to Sweet IRC")
                .font(.title)
            Form {
                TextField("Username: ", text: $viewModel.user.userName)
                TextField("Nickname: ", text: $viewModel.user.nickName)
                SecureField("Password: ", text: $viewModel.user.password)
                
                
                Picker("Server: ", selection: $viewModel.user.selectedServer) {
                    if viewModel.user.selectedServer == nil {
                        Text("Select an IRC Network")
                            .tag(nil as ServerInfo?)
                    }
                    ForEach(servers, id: \.name) { server in
                        Text("\(server.name)")
                            .tag(server as ServerInfo?)
                    }
                }
                .padding(.top)
            }
            .frame(maxWidth: 300)
            .padding()
            
            Button(action: {
                
            }) {
                Text("Connect")
                    .font(.headline)
                    .padding()
            }
            .padding([.top,.bottom])

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
