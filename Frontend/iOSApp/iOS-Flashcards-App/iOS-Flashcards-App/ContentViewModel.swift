//
//  ContentViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var user: User?
        
        public func userLoggedIn(_ u: User) -> Bool {
            if u.authToken == "" {
                return false
            }
            return true
        }
    }
}
