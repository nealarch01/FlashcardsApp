//
//  User.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

class User: ObservableObject {
    @Published private(set) var authToken: String = ""
    
    func setAuthToken(token: String) {
        self.authToken = token
    }
}
