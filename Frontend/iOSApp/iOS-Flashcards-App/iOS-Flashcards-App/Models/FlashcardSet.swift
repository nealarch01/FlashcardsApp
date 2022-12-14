//
//  FlashcardSet.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/9/22.
//

import Foundation

class FlashcardSet: ObservableObject {
    static public let titleMax: Int = 32
    static public let descriptionMax: Int = 300 // Maxes are inclusive
    
    private(set) var id: UInt64
    private(set) var creator_id: UInt64
    @Published private(set) var title: String
    @Published private(set) var description: String
    private(set) var created_at: String
    private(set) var isPrivate: Bool
    @Published public var cards: Array<Flashcard>
    
    
    init() {
        self.id = 0
        self.creator_id = 0
        self.title = "First Flashcard Set"
        self.description = "Sample flashcards"
        self.created_at = "Aug 8, 2022"
        self.isPrivate = false
        self.cards = [Flashcard(), Flashcard(), Flashcard(), Flashcard()] // Initialize
    }
    
    // Constructor to convert Decodable FlashcardSet
    init(decodedSet: FlashcardSetDecodable) {
        self.id = decodedSet.id
        self.creator_id = decodedSet.creator_id
        self.title = decodedSet.title
        self.description = decodedSet.description
        self.created_at = decodedSet.created_at
        self.isPrivate = decodedSet.private
        self.cards = []
        if decodedSet.cards == nil {
            return
        }
        
        // 
        for card in decodedSet.cards! {
            self.cards.append(Flashcard(decodedData: card))
        }
        
    }
    
    init(id: UInt64, creator_id: UInt64, title: String, description: String, created_at: String, isPrivate: Int, cards: Array<Flashcard>) {
        self.id = id
        self.creator_id = creator_id
        self.title = title
        self.description = description
        self.created_at = created_at
        self.isPrivate = isPrivate == 1 ? true : false
        self.cards = cards
    }
    
    public func updateTitle(newTitle: String) -> (Bool, String) {
        if newTitle.count > 50 {
            return (false, "Title must be 50 characters or less.")
        }
        
        return (true, "Successfully updated title")
    }
    
    public func updateDescription(newDescription: String) -> (Bool, String) {
        if newDescription.count >= 300 {
            return (false, "Description must be 300 characters or less")
        }
        return (true, "Successfully updated description")
    }
    
}





// Class for decoding API resposne
class FlashcardSetDecodable: Decodable {
    var id: UInt64
    var creator_id: UInt64
    var title: String
    var description: String
    var created_at: String
    var `private`: Bool
    var cards: Array<FlashcardDecodable>?
}









class FlashcardSetMetaData: ObservableObject {
    private(set) var id: UInt64
    private(set) var creator_id: UInt64
    @Published private(set) var title: String
    @Published private(set) var description: String
    private(set) var created_at: String
    private(set) var isPrivate: Bool
    
    init() {
        self.id = 0
        self.creator_id = 0
        self.creator_id = 0
        self.title = ""
        self.description = ""
        self.created_at = ""
        self.isPrivate = false
    }
}
