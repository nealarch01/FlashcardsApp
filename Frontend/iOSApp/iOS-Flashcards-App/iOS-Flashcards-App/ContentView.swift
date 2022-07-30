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
            if !viewModel.isLoggedIn() {
                AuthenticationView()
                    .environmentObject(user)
            } else {
                HomeView()
                    .environmentObject(user)
            }
        }.onAppear {
            viewModel.initUser(user)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
