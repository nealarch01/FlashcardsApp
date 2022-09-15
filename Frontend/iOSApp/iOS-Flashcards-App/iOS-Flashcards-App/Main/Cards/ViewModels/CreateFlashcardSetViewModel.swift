//
//  CreateFlashcardSetViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/24/22.
//

import Foundation


extension CreateFlashcardSetView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var titleInput: String
        @Published var descriptionInput: String
        @Published var isPrivate: Bool
        
        init() {
            self.titleInput = ""
            self.descriptionInput = ""
            self.isPrivate = false
        }
        
        public func togglePrivacy(_ privacyOption: String = "PUBLIC") { // Parameter is the button clicked
            // If the setting is re-clicked, do not update anything
            if privacyOption == "PRIVATE" && self.isPrivate || privacyOption == "PUBLIC" && !self.isPrivate {
                return
            }
            isPrivate.toggle()
        }
    }
}
