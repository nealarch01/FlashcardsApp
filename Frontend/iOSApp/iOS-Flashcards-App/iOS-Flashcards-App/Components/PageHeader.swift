//
//  PageHeader.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct PageHeader: View {
    let title: String
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(Color.appWhite)
                    .padding([.leading], 40)
                    .padding([.bottom], 20)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.queenBlue)
    }
}

struct PageHeader_Previews: PreviewProvider {
    static var previews: some View {
        PageHeader(title: "Title")
    }
}
