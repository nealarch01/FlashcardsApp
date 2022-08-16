//
//  FlashcardSetListView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/13/22.
//

import SwiftUI

struct FlashcardSetListView: View {
    @State var flashcardSets: Array<FlashcardSet>
    let title: String
    var body: some View {
        List {
            NavigationLink(destination: FlashcardSetView(flashcardSet: FlashcardSet())) {
                Text(flashcardSets[0].title)
            }
        }.navigationTitle(title)
    }
}

struct FlashcardSetListView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardSetListView(flashcardSets: [FlashcardSet()], title: "Flashcards")
    }
}
