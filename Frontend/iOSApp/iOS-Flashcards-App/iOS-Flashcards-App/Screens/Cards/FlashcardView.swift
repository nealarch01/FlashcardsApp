//
//  FlashcardView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 8/4/22.
//

import SwiftUI

struct FlashcardView: View {
    let flashcardData: Flashcard
    
    private let shortString: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    private let longString: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var isPresentedShown: Bool = true // True by default
    
    @State private var translation: CGSize = .zero
    @State private var cardRotation: Double = 0.0
    @State private var textRotation: Double = 0.0 // This is necessary. Without this, the text will be shown backwards
    
    private let slidePercentage: Double = 0.3 // 1/2 of the screen's width
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack { // ZStack to rotate
                    ZStack {
                        if isPresentedShown == true {
                            Text(flashcardData.presentedText)
                                .font(.system(size: 28, weight: .semibold))
                                .lineLimit(nil)
                                .padding()
                                .multilineTextAlignment(.center)
                        } else {
                            ScrollView {
                                Text(flashcardData.hiddenText)
                                    .font(.system(size: 22, weight: .regular))
                                    .lineLimit(nil)
                                    .padding()
                                    .multilineTextAlignment(.leading)
                            }
                            .clipped()
                        }
                    }
                    .rotation3DEffect(.degrees(textRotation), axis: (x: 0, y: 1, z: 0))
                }
                .frame(width: geometry.size.width * 0.9, height: 210)
                .background(Color.white, ignoresSafeAreaEdges: [])
                .cornerRadius(12)
                .shadow(radius: 15)
                .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 3)
                        .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                }
                
                .gesture (
                    DragGesture()
                        .onEnded { value in
                            flipCard(geometry: geometry, gesture: value)
                        }
                )
            }
            .frame(width: geometry.size.width)
        }
    }
    
    // Right swipe (finger starts from the right and ends at the left)
    private func flipCard(geometry: GeometryProxy, gesture: DragGesture.Value) -> Void {
        let dragPercentage = gesture.translation.width / geometry.size.width
        let flipDuration: Double = 0.21
        
        var rotationForText: Double
        
        if dragPercentage >= slidePercentage { // Finger starts from left, and ends right
            // Rotate from right -> left
            rotationForText = 180
            withAnimation(.easeOut(duration: flipDuration)) {
                self.cardRotation += 180
            }
        } else if dragPercentage <= -slidePercentage { // Finger starts from right, and ends left
            // Rotate from left -> right
            rotationForText = -180
            withAnimation(.easeOut(duration: flipDuration)) {
                self.cardRotation -= 180
            }
        } else {
            return
        }
        
        withAnimation(.easeOut(duration: 0).delay(flipDuration / 2.0)) { // Wait until half way flipped then change the text
            self.textRotation += rotationForText
            self.isPresentedShown.toggle()
        }
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView(flashcardData: Flashcard())
    }
}