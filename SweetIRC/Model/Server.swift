//
//  ServerInfo.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


struct Server: Hashable {
    let friendlyName: String
    let hostname: String
    let port: Int
}
