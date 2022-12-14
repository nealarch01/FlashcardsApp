//
//  EditFlashcardView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/10/22.
//

import SwiftUI

struct EditFlashcardView: View {
    @StateObject private var viewModel = ViewModel()
    
    @EnvironmentObject var user: User
    
    @StateObject var flashcardData: Flashcard
    
    // Input variables to be updated
    @State private var newPresented: String = ""
    @State private var newHidden: String = ""
    
    // Loading state to display progresse view on the Save button
    @State private var isLoading: Bool = false
    
    @State private var discardClicked: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userData: User
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Top Text")
                    .font(.system(size: 24, weight: .bold))
                    .padding([.leading], 10)
                TextField("Enter text", text: $newPresented)
                    .padding([.leading, .trailing])
                    .padding([.top], 10)
                    .padding([.bottom], 8)
                    .overlay(alignment: .bottom) {
                        Divider()
                            .frame(height: 2)
                            .background(Color.blue.opacity(0.9))
                    }
            }
            .padding([.bottom], 30)
            .overlay(alignment: .bottomTrailing) {
                Text("\(newPresented.count) / \(Flashcard.presentedMax)")
            }
            .padding([.leading, .trailing])
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Bottom Text")
                    .font(.system(size: 24, weight: .bold))
                    .padding([.bottom], 8)
                    .padding([.leading], 10)
                
                TextEditor(text: $newHidden)
                    .frame(height: 200)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    }
            }
            .padding([.bottom], 30)
            .overlay(alignment: .bottomTrailing) {
                Text("\(newHidden.count) / \(Flashcard.hiddenMax)")
            }
            .padding()
            
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.red)
            }
            
            HStack {
                Button(action: {
                    discardClicked = true // Show an alert
                }) {
                    Text("Discard Changes")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 60)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .alert("Are you sure you want to discard changes?", isPresented: $discardClicked) {
                    Button("Cancel", role: .cancel) {}
                    Button("Discard", role: .destructive) {
                        dismiss()
                    }
                }
                
                Button(action: {
                    // saveChanges()
                }) {
                    Text("Save Changes")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 60)
                        .background(Color.blue)
                        .cornerRadius(12)
                }.overlay(alignment: .trailing) {
                    if isLoading {
                        ProgressView()
                            .tint(Color.white)
                    }
                }
            }
            // Submit changes button
            
            Spacer()
        } // End of Root VStack
        .onAppear {
            // Initialize text with the current text of flashcard
            self.newPresented = flashcardData.presentedText
            self.newHidden = flashcardData.hiddenText
        }
        .onChange(of: newPresented) { newValue in
            if newValue.count > Flashcard.presentedMax {
                newPresented.removeLast(1) // Remove the last element O(k) algorithm where k = 1
            }
        }
        .onChange(of: newHidden) { newValue in
            if newValue.count > Flashcard.hiddenMax {
                newHidden.removeLast(1)
            }
        }
        .navigationTitle("Flashcard")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveChanges() {
        Task {
            let updateStatus = await viewModel.updateCard(newPresented: newPresented, newHidden: newHidden, cardID: flashcardData.id, authToken: userData.authToken)
            if updateStatus { // If successful, return
                dismiss() // Return back to the flashcards screen
            }
            
            // If updateCard was unsuccessful, then an error message will be displayed and we will not leave the view
            // Error message will be generated in the ViewModel
        }
    }
    
    private func discardChanges() {
        dismiss()
    }
    
}

struct EditFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditFlashcardView(flashcardData: Flashcard())
        }
    }
}
