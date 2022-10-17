//
//  CreateFlashcardViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/22/22.
//

import Foundation


extension CreateFlashcardView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var errorMessage: String = ""
        
        @Published var presented: String = ""
        @Published var hidden: String = ""
        
        @Published var isLoading: Bool = false
        
        // Purpose to return true / false is to toggle the show alert
        public func createNewCard(authToken: String, setID: UInt64) async -> Bool {
            let createStatus = await FlashcardService().createCard(presentedText: presented, hiddenText: hidden, authToken: authToken, setID: setID)
            if !createStatus.success {
                errorMessage = createStatus.message
                return false
            }
            return true
        }
        
    }
}
