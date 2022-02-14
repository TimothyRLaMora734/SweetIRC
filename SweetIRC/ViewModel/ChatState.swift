//
//  LoginViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


class ChatState: ObservableObject {
    
    @Published var user = User()
    
    @Published var isLoginDone = false
    
}
