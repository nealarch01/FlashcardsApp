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
                NavigationView {
                    VStack {
                        NavigationLink(destination: FlashcardSetView(flashcardSet: FlashcardSet())) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 12)
                                .overlay(alignment: .bottom) {
                                    Text("My Sets")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(Color.blue)
                                        .padding([.bottom], 20)
                                }
                        }
                        Button(action: {
                            viewModel.logout(user)
                        }) {
                            Text("Click here to logout")
                                .font(.system(size: 24))
                        }
                        .padding()
                    }
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
