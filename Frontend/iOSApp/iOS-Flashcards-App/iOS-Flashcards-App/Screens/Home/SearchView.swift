//
//  SearchView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/30/22.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        VStack {
            GeometryReader { geo in
                TextField("", text: $viewModel.searchInput)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass").padding([.leading], 10)
                            if viewModel.searchInput == "" {
                                Text("Search topics, flashcard sets, & users")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color.black.opacity(0.5))
                            }
                        }
                        ,alignment: .leading
                    )
                    .frame(width: geo.size.width * 0.9, height: 45)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.carolinaBlue, lineWidth: 2))
                    .frame(width: geo.size.width)
            }
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
