//
//  HomeViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

extension HomeView {
    @MainActor final class ViewModel: ObservableObject {
        public var user: User?
        
        func initUser(user: User) {
            self.user = user
        }
        
        func logout() {
            self.user!.authToken = "" // Reset auth token
        }
    }
}
