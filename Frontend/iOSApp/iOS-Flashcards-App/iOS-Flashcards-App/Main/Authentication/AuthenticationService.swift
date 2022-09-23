//
//  AuthenticationService.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import Foundation

fileprivate class LoginBodyParams: Codable {
    let userIdentifier: String
    let password: String
    
    init(userIdentifier: String, password: String) {
        self.userIdentifier = userIdentifier
        self.password = password
    }
}


fileprivate class RegisterBodyParams: Codable {
    let username: String
    let password: String
    let email: String
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
    }
}

fileprivate class AuthenticationResponse: Decodable {
    var token: String?
    var message: String?
    var active: Bool?
}


class AuthenticationService {
    private func postRequest(apiURL: URL, requestBody: Data) async -> (AuthenticationResponse?, Int?) {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        var responseData: AuthenticationResponse
        var httpStatusCode: Int
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for:  request)
            let httpURLResponse = urlResponse as? HTTPURLResponse // Note: HTTPURLResponse is a subclass of URLResponse
            if httpURLResponse == nil {
                return (nil, nil)
            }
            httpStatusCode = httpURLResponse!.statusCode
            responseData = try! JSONDecoder().decode(AuthenticationResponse.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            return (nil, nil)
        }
        return (responseData, httpStatusCode)
    }
    
    public func attemptLogin(userIdentifier: String, password: String) async -> AuthenticationStatus {
        let apiURL = URL(string: "http://127.0.0.1:1025/auth/login")!
        let httpBodyParams = try! JSONEncoder().encode(LoginBodyParams(userIdentifier: userIdentifier, password: password))
        let (authResponse, statusCode) = await postRequest(apiURL: apiURL, requestBody: httpBodyParams)
        if authResponse == nil || statusCode == nil {
            return AuthenticationStatus(successful: false, token: nil, message: "Error: Could not reach server.")
        }
        
        if statusCode! == 200 {
            return AuthenticationStatus(successful: true, token: authResponse!.token, message: "Successfully logged in!")
        }
        return AuthenticationStatus(successful: false, token: nil, message: "Error \(statusCode!): \(authResponse!.message!)")
    }
    
    public func createNewAccount(username: String, password: String, email: String) async -> AuthenticationStatus {
        let apiURL = URL(string: "http://127.0.0.1:1025/auth/register")!
        let registerBodyParams = try! JSONEncoder().encode(RegisterBodyParams(username: username, password: password, email: email))
        let (authResponse, statusCode) = await postRequest(apiURL: apiURL, requestBody: registerBodyParams)
        if authResponse == nil || statusCode == nil {
            return AuthenticationStatus(successful: false, token: nil, message: "Error: Could not reach server.")
        }
        if statusCode! == 201 {
            return AuthenticationStatus(successful: true, token: authResponse!.token, message: "Successfully created new account!")
        }
        return AuthenticationStatus(successful: false, token: nil, message: authResponse!.message)
    }
    
    public struct AuthenticationStatus {
        public var successful: Bool
        public var token: String?
        public var message: String?
        
        init(successful: Bool, token: String?, message: String?) {
            self.successful = successful
            self.token = token
            self.message = message
        }
    }
}




