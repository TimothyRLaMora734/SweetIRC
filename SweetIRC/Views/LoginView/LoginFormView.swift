//
//  LoginFormView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct LoginFormView: View {
    
    @ObservedObject var state: LoginState
    
    var body: some View {
        Form {
            TextField("Username: ", text: $state.user.userName, prompt: Text("Please enter the username"))
            SecureField("Password: ", text: $state.user.password, prompt: Text("Please enter the password"))
            TextField("Nickname: ", text: $state.user.nickName, prompt: Text("Please enter the nickname"))
            TextField("Real Name: ", text: $state.user.realName, prompt: Text("Please enter your real name"))

            
            Picker("Server", selection: $state.selectedIRCServer) {
                if state.selectedIRCServer == nil {
                    Text("Please selected a IRC server")
                        .tag(nil as ServerInfo?)
                }
                ForEach(servers, id: \.self) { server in
                    Text("\(server.friendlyName)")
                        .tag(server as ServerInfo?)
                }
            }
            .padding(.top)
        }
        .padding([.horizontal, .bottom])
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(state: LoginState() )
        
    }
}
