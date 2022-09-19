//
//  FlashcardOptionsViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/11/22.
//

import Foundation

extension EditFlashcardView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var errorMessage: String = ""
        
        public func updateCard(newPresented: String, newHidden: String, authToken: String? = nil) async -> Bool {
            // Although redudant, have this safety regardless (ie, someone pastes something that is over the character limit)
            if newPresented.count > Flashcard.presentedMax {
                errorMessage = "Top card has a maximum \(Flashcard.presentedMax) characters!"
                return false
            }
            
            if newPresented.count == 0 {
                errorMessage = "Your card must have a title!"
                return false
            }
            
            if newHidden.count > Flashcard.hiddenMax {
                errorMessage = "Bottom card has a maximum \(Flashcard.hiddenMax) characters."
                return false
            }
            
            // Implement API call here
            var request = URLRequest(url: URL(string: "http://127.0.0.1:1000/card/update/presented")!)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if authToken != nil {
                request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authroziation")
            }
            
            
            let updatedText = UpdateText(newPresented: newPresented, newHidden: newHidden)
            
            guard let encodedData = try? JSONEncoder().encode(updatedText) else {
                errorMessage = "An error occured. Try again."
                return false
            }
            
            request.httpBody = encodedData
            
            do {
                let (_, urlResponse) = try await URLSession.shared.data(for: request)
                
                guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                    print("Could not convert URL Response to HTTP Response")
                    errorMessage = "Could not update card."
                    return false
                }
                
                if httpUrlResponse.statusCode != 200 {
                    errorMessage = "Could not update card."
                    return false
                }
                
                return true
                
            } catch let error {
                print(error.localizedDescription)
                errorMessage = "Could not update card."
                return false // Unsuccessful return
            }
        }
    }
    
    private struct UpdateText: Encodable {
        public let newPresented: String
        public let newHidden: String
    }
}