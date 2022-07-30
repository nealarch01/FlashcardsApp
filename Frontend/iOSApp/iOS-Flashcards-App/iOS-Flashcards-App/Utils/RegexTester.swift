//
//  RegexTester.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/29/22.
//

import Foundation

class RegexTester {
    private func regexTest(regex: NSRegularExpression, string: String) -> Bool {
        let strRange = NSRange(location: 0, length: string.utf8.count)
        if regex.firstMatch(in: string, options: [], range: strRange) != nil {
            return true
        }
        return false
    }
    
    
    public func username(_ username: String) -> Bool {
        if username.count < 6 {
            return false
        }
        // Pound sign used to create raw strings (escape character does not escape literals"
        let regex = try! NSRegularExpression(pattern: #"^[0-9]*[a-zA-Z]([0-9a-zA-Z]|([._\-][0-9a-zA-Z]))*$"#) // Error propagation is disabled
        return regexTest(regex: regex, string: username)
    }
    
    
    public func password(_ password: String) -> Bool {
        if password.count < 6 {
            return false
        }
        let regex = try! NSRegularExpression(pattern: #"^[0-9a-zA-Z!@#\$%&\*_\-;.\/\{\}\[\]~()]+$"#)
        return regexTest(regex: regex, string: password)
    }
    
    
    public func email(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
        return regexTest(regex: regex, string: email)
    }
}
