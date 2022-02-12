//
//  IRCServers.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


let servers: [Server] = [Server(friendlyName: "Libera Chat", URL: URL(string: "irc://irc.libera.chat:6665")!, isTSL: false),
                             Server(friendlyName: "GIMPNet", URL: URL(string: "irc://irc.gnome.org:6668")!, isTSL: false),
                             Server(friendlyName: "Freenode", URL: URL(string: "irc://chat.freenode.net:6667")!, isTSL:  false)      ]
