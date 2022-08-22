//
//  CreateCardView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/21/22.
//

import SwiftUI

struct CreateFlashcardView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Text("Flashcard Title")
                        .font(.system(size: 24, weight: .bold))
                    TextField("Enter a title", text: $viewModel.titleInput)
                        .padding() // Applies padding to the placeholder text
                        .frame(width: geometry.size.width * 0.85, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    
                    Text("Description")
                        .font(.system(size: 24, weight: .bold))
                    TextEditor(text: $viewModel.descriptionInput)
                        .frame(width: geometry.size.width * 0.85, height: 200)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 2)
                        }
                } // End of VStack
                .padding(10)
                .frame(width: geometry.size.width) // Centers the VStack horizontally
            } // End of GeometryReader
            .frame(height: 365)
            
            HStack(spacing: 20) {
                Button(action: {
                    togglePrivacySetting(privacyOption: "PUBLIC")
                }) {
                    Text("Public")
                        .font(.system(size: 22, weight: .semibold))
                        .frame(width: 120, height: 45)
                        .foregroundColor(viewModel.isPrivate ? Color.blue : Color.white)
                        .background(viewModel.isPrivate ? Color.white : Color.blue)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    togglePrivacySetting(privacyOption: "PRIVATE")
                }) {
                    Text("Private")
                        .font(.system(size: 22, weight: .semibold))
                        .frame(width: 120, height: 45)
                        .foregroundColor(viewModel.isPrivate ? Color.white : Color.blue)
                        .background(viewModel.isPrivate ? Color.blue : Color.white)
                        .cornerRadius(12)
                }
            }
            
            HStack {
                Button(action: {}) {
                    Text("Cancel")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Text("Create")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding([.top])
            Spacer()
        } // End of Root VStack
        .navigationTitle("Create flashcard")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func togglePrivacySetting(privacyOption: String) {
        // If the setting is re-clicked, do not update anything
        if privacyOption == "PRIVATE" && viewModel.isPrivate {
            return
        } else if privacyOption == "PUBLIC" && !viewModel.isPrivate {
            return
        }
        
        let animation = Animation.easeOut(duration: 0.3)
        withAnimation(animation) {
            viewModel.togglePrivacy()
        }
    }
}

struct CreateFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        //        NavigationView {
        CreateFlashcardView()
        //        }
    }
}
