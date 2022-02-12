//
//  LoginViewModel.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation
import SwiftUI


class LoginViewModel: ObservableObject {
    
    @Published var user = UserInfo()
}
