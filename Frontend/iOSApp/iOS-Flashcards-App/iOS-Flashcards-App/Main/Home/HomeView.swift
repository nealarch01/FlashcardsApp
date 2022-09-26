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
            NavigationView {
                GeometryReader { geometry in
                    VStack(spacing: 40) {
                        NavigationLink(destination: FlashcardSetListView(flashcardSets: [], fetchType: FlashcardSetList.SetType.owned, title: "My Flashcard Sets")) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * 0.8, height: 100)
                                .shadow(radius: 12)
                                .overlay(alignment: .center) {
                                    Text("My Sets")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(Color.white)
                                }
                        }
                        .padding([.top], 10)
                        NavigationLink(destination: FlashcardSetListView(flashcardSets: [FlashcardSet()], fetchType: FlashcardSetList.SetType.owned, title:  "Saved Flashcard Sets")) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.pink)
                                .frame(width: geometry.size.width * 0.8, height: 100)
                                .shadow(radius:12)
                                .overlay(alignment: .center) {
                                    Text("Saved Sets")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(Color.white)
                                }
                        }
                        NavigationLink(destination: FlashcardSetListView(flashcardSets: [FlashcardSet()], fetchType: FlashcardSetList.SetType.owned, title: "Collaborated Sets")) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                                .frame(width: geometry.size.width * 0.8, height: 100)
                                .shadow(radius:12)
                                .overlay(alignment: .center) {
                                    Text("Collaborated Sets")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(Color.white)
                                }
                        }
                        Button(action: {
                            viewModel.logout(user)
                        }) {
                            Text("Click here to logout")
                                .font(.system(size: 24))
                        }
                    } // End of VStack
                    .frame(width: geometry.size.width) // Center the views horizontally inside GeometryReader
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.inline)
                } // End of Geometry Reader
            } // End of NavigationView
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            NavigationView {
                Text("Profile page!")
            }
                .tabItem {
                    Image(systemName: "person")
                    Text("My Profile")
                }
        } // End of TabView
//        .navigationViewStyle(.stack) // Specify this to prevent constraint error
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
