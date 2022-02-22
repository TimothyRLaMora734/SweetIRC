//
//  MessageTextArea.swift
//  SweetIRC
//
//  Created by Dan Stoian on 23.02.2022.
//

import SwiftUI

struct MessageTextAreaView: View {
    
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .frame(width: 640)
    }
}

struct MessageTextArea_Previews: PreviewProvider {
    static var previews: some View {
        MessageTextAreaView(text: .constant("lorem impsum"))
    }
}
