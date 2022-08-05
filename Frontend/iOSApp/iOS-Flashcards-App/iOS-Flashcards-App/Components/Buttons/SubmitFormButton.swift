//
//  SubmitFormButton.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

// Button that is used for authentication submission
struct SubmitFormButton: View {
    let text: String
    let submitAction: () async -> Void
    @Binding var showLoadingIndicator: Bool
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
        }.overlay(alignment: .trailing) {
            if showLoadingIndicator == true {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.white)
                    .padding([.trailing], 20)
            }
        }
    }
}

struct SubmitFormButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitFormButton(text: "", submitAction: {}, showLoadingIndicator: .constant(false))
    }
}
