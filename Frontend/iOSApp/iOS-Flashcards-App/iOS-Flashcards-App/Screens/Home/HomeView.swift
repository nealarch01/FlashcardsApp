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
        VStack {
            Text("Currently logged in")
                .font(.system(size: 26, weight: .bold))
            Button(action: {
                viewModel.logout()
            }) {
                Text("Click here to logout")
            }
            Spacer()
        }.onAppear {
            // Pass environment object into viewmodel
            viewModel.initUser(user: user)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
