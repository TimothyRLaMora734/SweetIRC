//
//  ChatView.swift
//  SweetIRC
//
//  Created by Dan Stoian on 14.02.2022.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var server: IRCClient
    @State var presentJoinRoomSheet = false
    var body: some View {
        NavigationView{
            RoomBarView()
                .frame(minWidth: 150)
        }
        .toolbar {
            Button(action: {
                server.listChannels()
                presentJoinRoomSheet.toggle()
            }, label: {
                Label("Join Room", systemImage: "plus")
            })
                .sheet(isPresented: $presentJoinRoomSheet, content: {
                    JoinRoomView(isPresented: $presentJoinRoomSheet)
                })
        }
        .frame(width: 800, height: 600)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(server)
    }
}


struct JoinRoomView: View {
    @EnvironmentObject var server: IRCClient
    @State var selectedRoom: Int?
    @Binding var isPresented: Bool

    var body: some View {
        Group {
            List(selection: $selectedRoom) {
                ForEach(server.channels, id: \.self) { channel in
                    Text("\(channel)")
                }
            }
            Button(selectedRoom != nil ? "Join \(selectedRoom!)" : "Join", action: {
                isPresented.toggle()
            })
            .disabled(selectedRoom == nil)
                .padding()
        }
        .frame(width: 300, height: 200)
    }
}
