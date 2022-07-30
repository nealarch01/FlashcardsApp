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
    var body: some View {
        VStack {
            if viewModel.activeAuthScreen == .REGISTER {
                PageHeader(title: "Sign Up")
                CaptionedTextField(caption: "Username", text: $viewModel.registerFormData.username, placeholder: "Enter username")
                CaptionedTextField(caption: "Email", text: $viewModel.registerFormData.email, placeholder: "Enter email")
                CaptionedTextField(caption: "Password", text: $viewModel.registerFormData.password, placeholder: "Enter password")
                CaptionedTextField(caption: "Confirm password", text: $viewModel.registerFormData.password, placeholder: "Enter confirm password")
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color.red)
                }
                SubmitFormButton(text: "Create Account", submitAction: {})
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
            } else {
                PageHeader(title: "Login")
                CaptionedTextField(caption: "Username/Email", text: $viewModel.loginFormData.userIdentifier, placeholder: "Enter username or email")
                    .padding([.top], 10)
                ViewableSecureField(caption: "Password", text: $viewModel.loginFormData.password, placeholder: "Enter password")
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(Color.red)
                }
                SubmitFormButton(text: "Login", submitAction: viewModel.login)
                    .padding([.top], 5)
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
        }.onAppear {
            viewModel.initUser(user: user)
        }
    }
    
    func doNothing() async -> Void {
        return
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
