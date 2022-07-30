//
//  SubmitFormButton.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct SubmitFormButton: View {
    let text: String
    let submitAction: () async -> Void
    var body: some View {
        Button(action: {
            Task {
                await submitAction()
            }
        }) {
            Text(text)
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(Color.appWhite)
                .frame(width: 310, height: 60)
                .background(Color.queenBlue)
                .cornerRadius(12)
        }
    }
}

struct SubmitFormButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitFormButton(text: "", submitAction: {})
    }
}
