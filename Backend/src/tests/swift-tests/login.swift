import Foundation
import Darwin

struct LoginBodyParams: Codable {
    var userIdentifier: String
    var password: String

    init(userIdentifier: String, password: String) {
        self.userIdentifier = userIdentifier
        self.password = password
    }
}

struct LoginResponse: Decodable {
    var token: String?
    var message: String?
}

func login(_ userIdentifier: String, _ password: String) async throws -> String {
    let apiURL = URL(string: "http://127.0.0.1:1000/auth/login")!
    
    var request = URLRequest(url: apiURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(LoginBodyParams(userIdentifier: userIdentifier, password: password))

    let (response, ab) = try await URLSession.shared.data(for: request)
    let httpResponse = ab as? HTTPURLResponse
    if httpResponse == nil {
        print("nil")
    } else {
        print(httpResponse!.statusCode)
    }
    let decoded = try JSONDecoder().decode(LoginResponse.self, from: response)

    if decoded.token == nil {
        return decoded.message!
    }
    return decoded.token!
}


func main() {
    print("Enter username or email: ")
    let username: String? = readLine()
    print("Enter password: ")
    let password: String? = readLine()
    Task {
        do {
            let token = try await login(username!, password!)
            print(token)
            exit(0)
        } catch let error {
            print(error.localizedDescription)
            exit(1)
        }
    }
    RunLoop.main.run()
}


main()