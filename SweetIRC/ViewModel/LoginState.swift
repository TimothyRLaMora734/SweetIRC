//
//  LoginViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation
import SwiftUI


class LoginState: ObservableObject {
    
    @Published var user = users[0]
    
    @Published var isLoginDone = false
    
    @Published var selectedIRCServer: ServerInfo? = servers[0]
    
    
    func canLogin() -> Bool {
        return user.userName != "" && user.password != "" && user.nickName != "" && selectedIRCServer != nil
        && user.realName != ""
    }

}
