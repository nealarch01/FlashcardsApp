//
//  ViewableSecureField.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct ViewableSecureField: View {
    let caption: String
    @Binding var text: String
    let placeholder: String
    
//    @State private var password: String = ""
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text(caption)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color.black)
                    Spacer()
                }
                .frame(width: 310)
                HStack {
                    if isSecure == true {
                        SecureField(placeholder, text: $text)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                    } else {
                        TextField(text == "" ? "Enter password" : text, text: $text)
                            .padding()
                            .frame(width: 310, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(12)
                            .disableAutocorrection(true)
                    }
                }.overlay(alignment: .trailing) {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure == true ? "eye.slash" : "eye")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.black)
                            .padding([.leading, .trailing], 10)
                            .frame(height: 45)
                    }
                }
            }
            .padding([.top, .bottom], 5)
            .frame(width: geometry.size.width)
        } // End of GeometryReader
        .frame(height: 100)
    }
}

struct ViewableSecureField_Previews: PreviewProvider {
    static var previews: some View {
        ViewableSecureField(caption: "Password", text: .constant(""), placeholder: "Enter password")
    }
}
