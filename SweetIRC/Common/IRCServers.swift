//
//  IRCServers.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


let servers: [Server] = [Server(friendlyName: "Libera Chat", hostname: "irc.libera.chat", port: 6665),
                         Server(friendlyName: "GIMPNet", hostname: "irc.gnome.org", port: 6668),
                         Server(friendlyName: "Freenode", hostname: "chat.freenode.net", port: 6667)      ]
