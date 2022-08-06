//
//  HomeView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var user: User
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        TabView {
            VStack(spacing: 20) {
                Text("Currently logged in")
                    .font(.system(size: 26, weight: .bold))
                Button(action: {
                    viewModel.logout(user)
                }) {
                    Text("Click here to logout")
                }
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            Text("Profile") // Create user settings view later
                .tabItem {
                    Image(systemName: "person")
                    Text("My Profile")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
