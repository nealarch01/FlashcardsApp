//
//  FlashcardService.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/20/22.
//

import Foundation

class FlashcardService {
    // Fetches the owned sets of the user logged in (takes in an AuthToken parameter)
    public func fetchOwnedSets(authToken: String) async -> (Array<FlashcardSet>, String?) {
        var flashcardSets: Array<FlashcardSet> = [] // Initialize as an empty array
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:1025/card-set/owned?metadata-only=true")!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            let httpURLResponse = urlResponse as? HTTPURLResponse
            if httpURLResponse == nil {
                return ([], "No URL Response")
            }
            
            if httpURLResponse!.statusCode != 200 {
                print("Status code did not return 200.")
                let decodedData = try? JSONDecoder().decode(WebAPIError.self, from: data)
                if decodedData == nil {
                    return ([], "No error message was received.")
                }
                return ([], decodedData!.message) // No need to unwrap optional since second return type is an Optional String
            }
            
            // Decode flashcard data into JSON
            let decodedData = try? JSONDecoder().decode([FlashcardSetDecodable].self, from: data)
            
            if decodedData == nil {
                print("An error occured. Could not decode flashcard set data.")
                return ([], "An error occured. Could not decode flashcard set data.")
            }
            
            // Convert FlashcardSetDecodable array into FlashcardSet array
            for i in 0 ..< decodedData!.count {
                flashcardSets.append(FlashcardSet(decodedSet: decodedData![i]))
            }
            
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
        return (flashcardSets, nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // Makes an API fetch to obtain cards in set data
    public func fetchCardsInSet(setID: UInt64, authToken: String) async -> (Array<Flashcard>, String?) {
        // Accept auth token to allow access to a set that is private to the user
        var request = URLRequest(url: URL(string: "http://127.0.0.1:1025/card-set/cards/\(setID)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            let httpURLResponse = urlResponse as? HTTPURLResponse
            
            if httpURLResponse == nil {
                return ([], "No URL Response")
            }
            
            if httpURLResponse!.statusCode != 200 {
                let decodedData = try? JSONDecoder().decode(WebAPIError.self, from: data)
                if decodedData == nil {
                    return ([], "No response was provided by the server.")
                }
                return ([], decodedData!.message)
            }
            
            let decodedData = try? JSONDecoder().decode(Array<FlashcardDecodable>.self, from: data)
            
            if decodedData == nil {
                return ([], "Could not decode flashcards")
            }
            
            
            // Convert FlashcardDecodable to Flashcard
            var cards: Array<Flashcard> = []
            for card in decodedData! {
                cards.append(Flashcard(decodedData: card))
            }
            
            return (cards, nil)
            
        } catch let error {
            print(error.localizedDescription)
            return ([], error.localizedDescription)
        }
    }
    
    
    // Makes an API call to change text
    // Returns true if the text was successfully updated
    public func updateCardText(newPresented: String, newHidden: String, cardID: UInt64, authToken: String) async -> Bool {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:1025/card/update-text/\(cardID)")!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authroziation")
        
        let updatedText = UpdateCardBody(newPresented: newPresented, newHidden: newHidden)
        
        
        // Encode the data
        guard let encodedData = try? JSONEncoder().encode(updatedText) else {
            return false
        }
        
        request.httpBody = encodedData // Add to the HTTP body
        
        do {
            let (_, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                print("Could not convert URL Response to HTTP Response")
                return false
            }
        
            if httpUrlResponse.statusCode != 200 {
                return false
            }
            
            return true
            
        } catch let error {
            print(error.localizedDescription)
            return false // Unsuccessful return
        }
    }
    
    
    public func createCard(presentedText: String, hiddenText: String, authToken: String, setID: UInt64) async -> (success: Bool, message: String) {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:1025/card/create")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        // Encode the data
        guard let encodedData = try? JSONEncoder().encode(CreateCardBody(presented: presentedText, hidden: hiddenText, setID: setID)) else {
            return (false, "Invalid text. Card not created.")
        }
        
        request.httpBody = encodedData
        
        // Then make the HTTP request
        
        do {
            let (responseData, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                return (false, "No response from server. Could not create card.")
            }
            
            if httpUrlResponse.statusCode != 201 {
                // Decode the data and return the error message
                guard let webApiError = try? JSONDecoder().decode(WebAPIError.self, from: responseData) else {
                    return (false, message: "No response from server. Could not create card.")
                }
                return (false, message: webApiError.message ?? "No message from server. Card not created.")
            }
            
            return (true, "Successfully created new card.")
            
        } catch let error {
            print("There was an error creating a new card")
            print(error.localizedDescription)
            return (false, "An error occured. Try again.")
        }
    }
    
}


private struct UpdateCardBody: Encodable {
    public let newPresented: String
    public let newHidden: String
}

private struct CreateCardBody: Encodable {
    public let presented: String
    public let hidden: String
    public let setID: UInt64
}

