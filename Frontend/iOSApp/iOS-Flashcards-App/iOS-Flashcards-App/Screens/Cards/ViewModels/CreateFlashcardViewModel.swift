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
    }
}
