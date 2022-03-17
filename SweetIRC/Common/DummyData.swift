//
//  IRCServers.swift
//  SweetIRC
//
//  Created by Dan Stoian on 12.02.2022.
//

import Foundation


let servers = [ServerInfo(friendlyName: "Libera Chat", hostname: "irc.libera.chat", port: 6697, domain: "libera.chat"),
                         ServerInfo(friendlyName: "GIMPNet", hostname: "irc.gnome.org", port: 6668, domain: "gnome.org"),
                         ServerInfo(friendlyName: "Freenode", hostname: "chat.freenode.net", port: 6667, domain: "freenode.net") ]


let users = [User(userName: "dirkAbend", nickName: "dirkTheGreat", realName: "Dirk AbendHoff", password: "dirkisthebest")]

let server = IRCClient(of: servers[0], as: users[0])
let rooms = [Room(name: "System Room", server: server)]
