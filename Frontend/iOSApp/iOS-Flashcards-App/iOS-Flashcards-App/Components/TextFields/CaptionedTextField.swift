//
//  CaptionedTextField.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct CaptionedTextField: View {
    let caption: String
    @Binding var text: String
    let placeholder: String
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(caption)
                        .font(.system(size: 22, weight: .medium))
                        .padding([.bottom], -2)
                        .foregroundColor(Color.black)
                    Spacer()
                }.frame(width: 310)
                
                TextField(placeholder, text: $text)
                    .padding()
                    .frame(width: 310, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                    .disableAutocorrection(true)
            }
            .padding([.top, .bottom], 5)
            .frame(width: geometry.size.width) // Center the view relative to screen size
        } // End of geometry reader
        .frame(height: 100)
    }
}

struct CaptionedTextField_Previews: PreviewProvider {
    static var previews: some View {
        CaptionedTextField(caption: "Username", text: .constant(""), placeholder: "Enter username")
    }
}
