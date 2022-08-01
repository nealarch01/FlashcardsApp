//
//  SearchViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/30/22.
//

import Foundation

extension SearchView {
    @MainActor final class ViewModel: ObservableObject {
        @Published public var searchInput: String = ""
        
        
    }
}
