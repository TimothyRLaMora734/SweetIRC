//
//  ServerInfo.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


struct ServerInfo: Hashable {
    let name: String
    let URL: URL
    let isTSL: Bool
}
