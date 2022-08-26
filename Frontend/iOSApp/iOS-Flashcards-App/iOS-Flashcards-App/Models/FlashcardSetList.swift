//
//  FlashcardSetList.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/24/22.
//

import Foundation

class FlashcardSetList {
    private(set) var sets: Array<FlashcardSet>
    
    public init() {
        sets = []
    }
    
    
    enum SetType {
        case owned
        case none
        case saved
    }
}
