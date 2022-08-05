//
//  AuthenticationView.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var user: User
    @StateObject private var viewModel = ViewModel()
    @State private var isLoading: Bool = false
    var body: some View {
        VStack {
            if viewModel.activeAuthScreen == .REGISTER { // Register page condition
                PageHeader(title: "Sign Up")
                CaptionedTextField(caption: "Username", text: $viewModel.registerFormData.username, placeholder: "Enter username")
                CaptionedTextField(caption: "Email", text: $viewModel.registerFormData.email, placeholder: "Enter email")
                ViewableSecureField(caption: "Password", text: $viewModel.registerFormData.password, placeholder: "Enter password")
                ViewableSecureField(caption: "Confirm password", text: $viewModel.registerFormData.confirmedPassword, placeholder: "Enter confirm password")
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color.red)
                }
                Button(action: {
                    isLoading.toggle()
                    Task {
                        await viewModel.register(user: self.user)
                    }
                    isLoading.toggle()
                }) {
                    Text("Sign Up")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color.appWhite)
                        .frame(width: 310, height: 60)
                        .background(Color.queenBlue)
                        .cornerRadius(12)
                    if isLoading == true {
                        ProgressView()
                    }
                }
                .overlay(alignment: .trailing) {
                    if isLoading == true {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.white)
                            .padding([.trailing], 20)
                    }
                }
                .padding([.top], 5)
                
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .font(.system(size: 20, weight: .medium))
                    Button(action: {
                        viewModel.changeAuthScreen()
                    }) {
                        Text("Sign in")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.carolinaBlue)
                    }
                }.padding([.top], 10)
            } else { // Login page
                PageHeader(title: "Login")
                CaptionedTextField(caption: "Username/Email", text: $viewModel.loginFormData.userIdentifier, placeholder: "Enter username or email")
                    .padding([.top], 10)
                ViewableSecureField(caption: "Password", text: $viewModel.loginFormData.password, placeholder: "Enter password")
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color.red)
                }
                Button(action: {
                    isLoading.toggle()
                    Task {
                        await viewModel.login(user: self.user)
                    }
                    isLoading.toggle()
                }) {
                    Text("Login")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(Color.appWhite)
                        .frame(width: 310, height: 60)
                        .background(Color.queenBlue)
                        .cornerRadius(12)
                }
                .padding([.top], 5)
                .overlay(alignment: .trailing) {
                    if isLoading == true {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.white)
                            .padding([.trailing], 20)
                    }
                }
                
                // Change screen text and button
                HStack(spacing: 5) {
                    Text("Don't have an account?")
                        .font(.system(size: 20, weight: .medium))
                    Button(action: {
                        viewModel.changeAuthScreen()
                    }) {
                        Text("Sign up")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.carolinaBlue)
                    }
                }.padding([.top], 10)
            }
            
            Spacer()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
