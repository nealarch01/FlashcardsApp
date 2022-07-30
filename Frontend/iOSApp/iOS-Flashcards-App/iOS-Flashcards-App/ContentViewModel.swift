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
        
        public func initUser(_ user: User) {
            self.user = user
        }
        
        public func isLoggedIn() -> Bool {
            if self.user != nil {
                if self.user!.authToken == "" {
                    return false
                }
                return true
            }
            return false
        }
        
        
    }
}
