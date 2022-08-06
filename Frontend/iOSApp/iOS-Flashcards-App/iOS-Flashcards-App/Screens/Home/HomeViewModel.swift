//
//  HomeViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

extension HomeView {
    @MainActor final class ViewModel: ObservableObject {
        func logout(_ user: User) {
            user.setAuthToken(token: "")
        }
    }
}
