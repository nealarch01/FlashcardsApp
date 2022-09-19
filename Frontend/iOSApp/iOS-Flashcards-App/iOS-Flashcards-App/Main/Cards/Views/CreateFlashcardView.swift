//
//  CreateCardView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/21/22.
//

import SwiftUI

struct CreateFlashcardView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var presented: String = ""
    @State private var hidden: String = ""
    @State private var isLoading: Bool = false
    
    @State private var discardClicked: Bool = false

    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Top Text")
                    .font(.system(size: 24, weight: .bold))
                    .padding([.leading], 10)
                TextField("Enter text", text: $viewModel.presented)
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
                Text("\(viewModel.presented.count) / \(Flashcard.presentedMax)")
            }
            .padding([.leading, .trailing])
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Bottom Text")
                    .font(.system(size: 24, weight: .bold))
                    .padding([.bottom], 8)
                    .padding([.leading], 10)
                
                TextEditor(text: $viewModel.hidden)
                    .frame(height: 200)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    }
            }
            .padding([.bottom], 30)
            .overlay(alignment: .bottomTrailing) {
                Text("\(viewModel.hidden.count) / \(Flashcard.hiddenMax)")
            }
            .padding()
            
            if viewModel.errorMessage != "" {
                Text(viewModel.errorMessage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.red)
            }
            
            HStack {
                Button(action: {
                    discardClicked = true
                }) {
                    Text("Discard")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 60)
                        .background(Color.red)
                        .cornerRadius(12)
                }.alert("Are you sure you want to discard?", isPresented: $discardClicked) {
                    Button("Cancel", role: .cancel) {}
                    Button("Discard", role: .destructive) {
                        dismiss()
                    }
                }
                
                Button(action: {  }) {
                    Text("Create")
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
        }
        .navigationTitle("Create flashcard")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func discardAlert() {
        
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        CreateFlashcardView()
        }
    }
}
