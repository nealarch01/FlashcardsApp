//
//  Flashcard.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/4/22.
//

import Foundation

class Flashcard {
    private(set) var id: Int
    private(set) var presentedText: String // The "concept" / title card
    private(set) var hiddenText: String // The description card
    
    // Default constructor
    public init() {
        self.id = 0
        self.presentedText = "Lorem ipsum"
        self.hiddenText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    }
    
    public init(id: Int, presentedText: String, hiddenText: String) {
        self.id = id
        self.presentedText = presentedText
        self.hiddenText = hiddenText
    }
    
    // Steps for updating card
    // 1. Verify text size (must be checked in the
    // 2. Update locally
    // 3. Make API Request and update in the SQL database
    
    public func updateHiddenText(newText: String) -> String {
        if newText.count >= 500 {
            return "Hidden text must be less than 500 characters"
        }
        return "Updated text!"
    }
    
    public func updatePresentedText(newText: String) -> String {
        if newText.count >= 50 {
            return "Presented text must be less than 300 characters"
        }
        return "Updated text!"
    }
}

class FlashcardDecodable: Decodable {
    var id: Int
    var presented: String
    var hidden: String
    
    init() {
        self.id = 0
        presented = "null"
        hidden = "null"
    }
}

