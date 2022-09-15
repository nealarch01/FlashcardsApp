//
//  FlashcardSetView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/9/22.
//

import SwiftUI


struct FlashcardSetView: View {
    @StateObject private var viewModel = ViewModel()
    @EnvironmentObject var user: User
    
    @StateObject var flashcardSet: FlashcardSet // Reqiured parameter
    
    @State private var expandOptions: Bool = false
    @State private var editModeOn: Bool = false
    
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    HStack {
                        Text(viewModel.flashcardSet.description)
                            .font(.system(size: 24, weight: .regular))
                            .padding([.leading])
                        Spacer()
                    }
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 2)
                        .padding([.bottom])
                }
                VStack(spacing: 50) {
                    if flashcardSet.cards.count == 0 {
                        Text("No cards in set.")
                            .font(.system(size: 24, weight: .bold))
                    } else {
                        ForEach(Array(viewModel.flashcardSet.cards.enumerated()), id: \.offset) { (index: Int, _: Flashcard) in
                            HStack {
                                FlashcardView(flashcardData: viewModel.flashcardSet.cards[index])
                                if (editModeOn) {
                                    VStack(spacing: 10) {
                                        NavigationLink (
                                            destination: EditFlashcardView(flashcardData: viewModel.flashcardSet.cards[index])) {
                                                Image(systemName: "chevron.right")
                                                    .font(.system(size: 28))
                                                    .foregroundColor(Color.white)
                                                    .frame(width: 50, height: 70)
                                                    .background(Color.blue)
                                                    .cornerRadius(12)
                                            }
                                        Button(action: {
                                            showDeleteAlert.toggle()
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color.white)
                                                .frame(width: 50, height: 70)
                                                .background(Color.red)
                                                .cornerRadius(12)
                                        }
                                        .alert("Are you sure you want to delete this card?", isPresented: $showDeleteAlert) {
                                            Button("Cancel", role: .cancel) {} // Do nothing
                                            Button("Confirm", role: .destructive) {
                                                // Attempt to delete card from web API
                                                // Then delete from UI, re-render
                                            }
                                        }
                                    }
                                    .padding([.trailing])
                                } // End of Conditional render statement
                            } // End of HStack
                        } // End of ForEach
                    }
                } // End of VStack
                .padding([.bottom], 20)
            }
            .navigationTitle(viewModel.flashcardSet.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(destination: CreateFlashcardView()) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 26))
                                .foregroundColor(Color.green)
                        }
                        Button(action: { toggleEditMode() }) {
                            Image(systemName: !editModeOn ? "pencil.circle" : "pencil.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color.blue)
                        }
                    }
                } // End of trailing ToolbarItem
            } // End of navigationTitle
        } // End of ZStack
        .onAppear {
            print("API Fetch Made") // Additionally, API will update afted a description is updated
            viewModel.flashcardSet = self.flashcardSet // Initialize ViewModel set
            Task {
                let cards = await viewModel.fetchCards(authToken: user.authToken)
                flashcardSet.cards = cards
            }
        }
        .onDisappear {
            flashcardSet.cards = [] // Unset cards
        }
    }
    
    private func toggleOptions() {
        self.expandOptions.toggle()
    }
    
    private func toggleEditMode() {
        withAnimation(.easeOut(duration: 0.4)) {
            self.editModeOn.toggle()
        }
    }
}

struct FlashcardSetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlashcardSetView(flashcardSet: FlashcardSet())
                .environmentObject(User())
        }
    }
}
