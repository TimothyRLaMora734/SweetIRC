//
//  User.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


struct User {
    var userName = ""
    var nickName = ""
    var realName = ""
    var password = ""
    
    var selectedIRCServer: Server?
    
    
    func canLogin() -> Bool {
        return userName != "" && password != "" && nickName != "" && selectedIRCServer != nil
                    && realName != ""
    }
}
