//
//  FlashcardOptionsViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/11/22.
//

import Foundation

extension EditFlashcardView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var errorMessage: String = ""
        
        public func updateCard(newPresented: String, newHidden: String, cardID: UInt64, authToken: String) async -> Bool {
            // Although redudant, have this safety regardless (ie, someone pastes something that is over the character limit)
            if newPresented.count > Flashcard.presentedMax {
                errorMessage = "Top card has a maximum \(Flashcard.presentedMax) characters!"
                return false
            }
            
            if newPresented.count == 0 {
                errorMessage = "Your card must have a title!"
                return false
            }
            
            if newHidden.count > Flashcard.hiddenMax {
                errorMessage = "Bottom card has a maximum \(Flashcard.hiddenMax) characters."
                return false
            }
            
            let updateStatus = await FlashcardService().updateCardText(newPresented: newPresented, newHidden: newHidden, cardID: cardID, authToken: authToken)
            
            if updateStatus == false {
                errorMessage = "Could not update card. Try again."
                return false
            }
            
            return true
            
        } // End of updateCardFunction
    }
}
