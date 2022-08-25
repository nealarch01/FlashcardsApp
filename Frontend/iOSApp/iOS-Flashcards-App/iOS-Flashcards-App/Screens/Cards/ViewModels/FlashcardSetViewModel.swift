//
//  FlashcardSetViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/11/22.
//

import Foundation

extension FlashcardSetView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var flashcardSet: FlashcardSet = FlashcardSet() // Default constructor
        @Published var errorMessage: String = ""
        
        public func fetchCards(authToken: String) async -> Array<Flashcard> {
            let setID = self.flashcardSet.id
            let (cards, err) = await FlashcardService().fetchCardsInSet(setID: setID, authToken: authToken)
            if err != nil {
                errorMessage = err!
                print(errorMessage)
                return []
            }
            return cards
        }
    }
}
