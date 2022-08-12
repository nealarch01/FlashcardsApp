//
//  FlashcardSetView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/9/22.
//

import SwiftUI


struct FlashcardSetView: View {
    @StateObject var viewModel = ViewModel()
    @StateObject var flashcardSet: FlashcardSet
    
    @State private var expandOptions: Bool = false
    @State private var editModeOn: Bool = false
    
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
                    ForEach(Array(viewModel.flashcardSet.cards.enumerated()), id: \.offset) { (index: Int, _: Flashcard) in
                        HStack {
                            FlashcardView(flashcardData: viewModel.flashcardSet.cards[index])
                            if (editModeOn) {
                                NavigationLink (
                                    destination: FlashcardOptionView(flashcardData: viewModel.flashcardSet.cards[index])) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color.white)
                                            .frame(width: 50, height: 70)
                                            .background(Color.blue)
                                            .cornerRadius(12)
                                            .padding([.trailing])
                                    }
                            }
                        }
                    }
                }
                .padding([.bottom], 20)
            }
            .navigationTitle(viewModel.flashcardSet.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Button(action: { toggleOptions() }) {
                            Image(systemName: !expandOptions ? "plusminus.circle" : "plusminus.circle.fill")
                                .foregroundColor(Color.blue)
                        }
                        if expandOptions {
                            Button(action: {}) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(Color.red)
                            }
                            Button(action: {}) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(Color.green)
                            }
                        }
                    }
                    .font(.system(size: 26))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { toggleEditMode() }) {
                        Image(systemName: !editModeOn ? "pencil.circle" : "pencil.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(Color.blue)
                    }
                }
            }
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
        FlashcardSetView(flashcardSet: FlashcardSet())
    }
}
