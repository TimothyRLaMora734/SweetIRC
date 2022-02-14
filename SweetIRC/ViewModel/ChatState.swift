//
//  LoginViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation
import SwiftUI


class ChatState: ObservableObject {
    
    @Published var user = User()
    
    @Published var isLoginDone = false
    
}
