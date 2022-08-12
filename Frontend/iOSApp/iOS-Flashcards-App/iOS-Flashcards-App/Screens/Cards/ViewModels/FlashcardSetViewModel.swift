//
//  FlashcardSetViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/11/22.
//

import Foundation

extension FlashcardSetView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var flashcardSet: FlashcardSet
        
        init() {
            flashcardSet = FlashcardSet()
        }
    }
}
