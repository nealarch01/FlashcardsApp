//
//  CreateFlashcardViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/22/22.
//

import Foundation


extension CreateFlashcardView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var titleInput: String
        @Published var descriptionInput: String
        @Published var isPrivate: Bool
        
        init() {
            self.titleInput = ""
            self.descriptionInput = ""
            self.isPrivate = false
        }
        
        public func togglePrivacy() {
            isPrivate.toggle()
        }
    }
}
