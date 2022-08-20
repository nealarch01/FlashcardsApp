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
    
    public func updateText(newPresented: String, newHidden: String) {
        self.presentedText = newPresented
        self.hiddenText = newHidden
    }
    
    public func hiddenTextValid(newText: String) -> (successful: Bool, message: String) {
        if newText.count >= Flashcard.hiddenMax {
            return (false, "Text must be less than 500 characters")
        }
        return (true, "Successfully updated card")
    }
    
    public func presentedTextValid(newText: String) -> (successful: Bool, message: String) {
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



class FlashcardSet: ObservableObject {
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
        self.cards = [Flashcard(), Flashcard(), Flashcard(), Flashcard()] // Initialize by default
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
}


class APIErrorResponse: Decodable {
    var message: String?
}

func fetchOwnedSets(authToken: String) async -> Void {
    // var sets: Array<FlashcardSet> = []
    var request = URLRequest(url: URL(string: "http://127.0.0.1:1000/card-set/owned")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    var resData: Data
    do {
        let (responseData, urlResponse) = try await URLSession.shared.data(for: request)
        let httpResponse = urlResponse as? HTTPURLResponse

        resData = responseData

        let response = try JSONDecoder().decode(Array<FlashcardSetDecodable>.self, from: resData)
        print(response)

        if httpResponse == nil {
            print("Error: No response from server")
            return
        }

        print(httpResponse!.statusCode)

    } catch let error {
        print(error.localizedDescription)
        exit(1)
    }

    exit(0)
}


func fetchCardSet(setID: Int = 1) async -> Void {
    var request = URLRequest(url: URL(string: "http://127.0.0.1:1000/card-set/metadata/\(setID)")!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    // request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    var resData: Data
    do {
        let (responseData, urlResponse) = try await URLSession.shared.data(for: request)
        let httpResponse = urlResponse as? HTTPURLResponse
        if httpResponse == nil {
            print("No response received")
            exit(1)
        }
        resData = responseData
    } catch let error {
        print(error.localizedDescription)
        exit(1)
    }

    let decoded = try? JSONDecoder().decode(FlashcardSetDecodable.self, from: resData)
    if decoded == nil {
        print("Could not decode response")
        exit(1)
    }
    print("Successfully decoded!")
    exit(0)
}

func main() {
    Task {
        await fetchOwnedSets(authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjozLCJpYXQiOjE2NjEwMjc0MTcsImV4cCI6MTY2MTExMzgxN30.7wBxEgdIC70Nu91oo0FMnOd0dKoNzqHO7u3U5v9RYWE")
        // await fetchCardSet()
    }
    RunLoop.main.run()
}


main()