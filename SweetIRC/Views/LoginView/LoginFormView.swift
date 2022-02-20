//
//  LoginFormView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct LoginFormView: View {
    
    @Binding var user: User
    
    var body: some View {
        Form {
            TextField("Username: ", text: $user.userName, prompt: Text("Please enter the username"))
            SecureField("Password: ", text: $user.password, prompt: Text("Please enter the password"))
            TextField("Nickname: ", text: $user.nickName, prompt: Text("Please enter the nickname"))
            TextField("Real Name: ", text: $user.realName, prompt: Text("Please enter your real name"))

            
            Picker("Server", selection: $user.selectedIRCServer) {
                if user.selectedIRCServer == nil {
                    Text("Please selected a IRC server")
                        .tag(nil as Server?)
                }
                ForEach(servers, id: \.self) { server in
                    Text("\(server.friendlyName)")
                        .tag(server as Server?)
                }
            }
            .padding(.top)
        }
        .padding([.horizontal, .bottom])
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(user: .constant(User()) )
        
    }
}
