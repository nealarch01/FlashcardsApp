//
//  FlashcardSetListViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/24/22.
//

import Foundation

extension FlashcardSetListView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var errorMessage: String = ""
        
        public func fetchFlashcardSets(fetchType: FlashcardSetList.SetType, authToken: String) async -> Array<FlashcardSet> {
            var sets: Array<FlashcardSet>
            var err: String?
            switch fetchType {
            case .owned:
                (sets, err) = await FlashcardService().fetchOwnedSets(authToken: authToken)
                break                
                
            case .test:
                sets = [FlashcardSet()] // One test set of Lorem Ipsum
                break
            default: 
                sets = []
                break
            }
            
            if err != nil {
                errorMessage = err!
                return []
            }
            
            return sets
        }
        
    }
}
