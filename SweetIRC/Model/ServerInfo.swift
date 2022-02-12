//
//  ServerInfo.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


struct Server: Hashable {
    let friendlyName: String
    let URL: URL
    let isTSL: Bool
}
