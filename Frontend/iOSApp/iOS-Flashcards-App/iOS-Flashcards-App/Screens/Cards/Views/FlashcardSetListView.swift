//
//  FlashcardSetListView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/13/22.
//

import SwiftUI



struct FlashcardSetListView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State var flashcardSets: Array<FlashcardSet>
    
    let fetchType: FlashcardSetList.SetType
    
    let title: String
    
    @State private var isLoading: Bool = false
    
    
    @EnvironmentObject private var user: User
    
    var body: some View {
        ZStack {
            if flashcardSets.count == 0 {
                VStack {
                    Text("No flashcard sets.")
                        .font(.system(size: 24, weight: .medium))
                        .padding([.top], 15)
                    Spacer()
                }
            } else {
                List {
                    ForEach(flashcardSets, id: \.self.id) { flashcardSet in
                        NavigationLink(destination: FlashcardSetView(flashcardSet: flashcardSet)) {
                            Text(flashcardSet.title)
                        }
                    }
                } // End of list
            }
        } // End of ZStack
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("New")
                }
            } // End of ToolbarItem
        } // End of toolbar
        .onAppear {
            Task {
                let response = await viewModel.fetchFlashcardSets(fetchType: .owned, authToken: self.user.authToken)
                flashcardSets = response // Note, this does not obtain flashcard sets
            }
        }
    }
    
    private func deleteFlashcardSet() {
        return
    }
}

struct FlashcardSetListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashcardSetListView(flashcardSets: [], fetchType: FlashcardSetList.SetType.owned, title: "Flashcards")
                .environmentObject(User())
        }
    }
}
