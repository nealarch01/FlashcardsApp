//
//  Flashcard.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/4/22.
//

import Foundation

class Flashcard: ObservableObject {
    static public let presentedMax: Int = 50 // 50 Characters max
    static public let hiddenMax: Int = 500
    
    private(set) var id: UInt64
    // Make text Published to allow UI changes / updates when a card is modified
    @Published private(set) var presentedText: String // The "concept" / title card
    @Published private(set) var hiddenText: String // The description card
    
    // Default constructor
    public init() {
        self.id = 0
        self.presentedText = "Lorem ipsum"
        self.hiddenText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    }
    
    public init(id: UInt64, presentedText: String, hiddenText: String) {
        self.id = id
        self.presentedText = presentedText
        self.hiddenText = hiddenText
    }
    
    // Steps for updating card
    // 1. Verify text size (must be checked in the
    // 2. Update locally
    // 3. Make API Request and update in the SQL database
    
    public func updateHiddenText(newText: String) -> (Bool, String) {
        if newText.count >= Flashcard.hiddenMax {
            return (false, "Text must be less than 500 characters")
        }
        return (true, "Successfully updated card")
    }
    
    public func updatePresentedText(newText: String) -> (Bool, String) {
        if newText.count >= Flashcard.presentedMax {
            return (false, "Presented text must be less than 300 characters")
        }
        return (true, "Successfully updated card")
    }
}

class FlashcardDecodable: Decodable {
    var id: UInt64
    var presented: String
    var hidden: String
    
    init() {
        self.id = 0
        presented = "null"
        hidden = "null"
    }
}

