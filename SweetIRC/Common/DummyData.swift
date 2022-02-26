//
//  IRCServers.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


let servers = [Server(friendlyName: "Libera Chat", hostname: "irc.libera.chat", port: 6697),
                         Server(friendlyName: "GIMPNet", hostname: "irc.gnome.org", port: 6668),
                         Server(friendlyName: "Freenode", hostname: "chat.freenode.net", port: 6667)      ]


let users = [User(userName: "dirkAbend", nickName: "dirkTheGreat", realName: "Dirk AbendHoff", password: "dirkisthebest")]
