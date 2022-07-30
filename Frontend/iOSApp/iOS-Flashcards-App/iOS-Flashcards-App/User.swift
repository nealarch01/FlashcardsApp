//
//  User.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

class User: ObservableObject {
    @Published var authToken: String = ""
    @Published var isLoggedIn: Bool = false
}
