//
//  ContentView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var user: User
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        ZStack {
            Color.appWhite
                .ignoresSafeArea(edges: [.all]) // Global background color
            if !viewModel.userLoggedIn(user)  { // This will cause Canvas to crash but when ran on Simulator, won't crash
                AuthenticationView()
            } else {
                HomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
