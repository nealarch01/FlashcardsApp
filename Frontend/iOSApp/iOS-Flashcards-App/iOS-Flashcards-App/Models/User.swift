//
//  User.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

class User: ObservableObject {
    @Published private(set) var authToken: String
    
    init() {
        authToken = "" // Initialize as an empty string by default
    }
    
    
    init(authToken: String) {
        self.authToken = authToken
    }
    
    func setAuthToken(token: String) {
        self.authToken = token
    }
}
