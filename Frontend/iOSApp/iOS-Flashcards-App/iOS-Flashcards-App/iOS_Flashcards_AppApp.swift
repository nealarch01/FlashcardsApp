//
//  iOS_Flashcards_AppApp.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

@main
struct iOS_Flashcards_AppApp: App {
    @StateObject var user = User()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
        }
    }
}
