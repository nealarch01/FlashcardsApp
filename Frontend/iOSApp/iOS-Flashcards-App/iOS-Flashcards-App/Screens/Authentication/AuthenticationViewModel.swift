//
//  AuthenticationViewModel.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

extension AuthenticationView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var activeAuthScreen: AuthType = .LOGIN // Login by default
        
        @Published var loginFormData = LoginFormVars()
        @Published var registerFormData = RegisterFormVars()
        
        @Published var errorMessage: String = ""
        
        private var user: User? // Environment Object
        
        private let regexTester = RegexTester()
        
        enum AuthType {
            case LOGIN
            case REGISTER
        }
        
        public func changeAuthScreen() {
            if activeAuthScreen == .LOGIN {
                activeAuthScreen = .REGISTER // Switch to Register
                loginFormData.userIdentifier = ""
                loginFormData.password = ""
            } else {
                activeAuthScreen = .LOGIN // Switch to login
                registerFormData.username = ""
                registerFormData.password = ""
                registerFormData.confirmedPassword = ""
                registerFormData.email = ""
            }
            errorMessage = ""
        }
        
        func login() async {
            let userIdentifier = self.loginFormData.userIdentifier
            let password = self.loginFormData.password
            if userIdentifier.contains("@") {
                if !self.regexTester.email(userIdentifier) {
                    errorMessage = "Email is invalid."
                    return
                }
            } else {
                if !self.regexTester.username(userIdentifier) {
                    errorMessage = "Username is invalid."
                    return
                }
            }
            
            if !self.regexTester.password(password) {
                self.errorMessage = "Invalid password."
                return
            }
            
            let loginResponse = await AuthenticationModel()
                .attemptLogin(userIdentifier: userIdentifier, password: password)
            if loginResponse.successful == true {
                self.user!.setAuthToken(token: loginResponse.token!)
            } else {
                self.errorMessage = loginResponse.message ?? "Could not login. Try again."
            }
        }
        
        func register() async {
            let username = self.registerFormData.username
            let password = self.registerFormData.password
            let password2 = self.registerFormData.confirmedPassword
            let email = self.registerFormData.email
            
            if !self.regexTester.username(username) {
                errorMessage = "Invalid username format. Username cannot contain spaces and must contain at least 6 characters. Hyphens, underscores, and periods are allowed but cannot be in succession."
                return
            }
            
            if password != password2 {
                errorMessage = "Passwords do not match."
                return
            }
            
            if !self.regexTester.password(password) {
                errorMessage = "Invalid password. Passwords can only contain !@#$%^&*(){}[]:;|.,<>?/-= and must be at least 6 characters long"
                return
            }
            
            if !self.regexTester.email(email) {
                errorMessage = "Invalid email."
                return
            }
            
            
            let registerResponse = await AuthenticationModel()
                .createNewAccount(username: self.registerFormData.username, password: self.registerFormData.password, email: self.registerFormData.email)
            if registerResponse.successful == true {
                self.user!.setAuthToken(token: registerResponse.token!)
            } else {
                self.errorMessage = registerResponse.message ?? "Could not create account. Try again."
            }
        }
        
        func initUser(user: User) {
            self.user = user
        }
    }
    
    class LoginFormVars: ObservableObject {
        @Published var userIdentifier: String = ""
        @Published var password: String = ""
    }
    
    class RegisterFormVars: ObservableObject {
        @Published var username: String = ""
        @Published var password: String = ""
        @Published var confirmedPassword: String = ""
        @Published var email: String = ""
    }
}
