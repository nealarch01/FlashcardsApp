//
//  ContentViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        public func userLoggedIn(_ user: User) -> Bool {
            if user.authToken == "" {
                return false
            }
            return true
        }
    }
}
