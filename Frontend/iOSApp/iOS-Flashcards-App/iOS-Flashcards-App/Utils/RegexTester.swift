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
        // Pound sign used to create raw strings (escape character does not escape literals"
        let regex = try! NSRegularExpression(pattern: #"^[0-9]*[a-zA-Z]([0-9a-zA-Z]|([._\-][0-9a-zA-Z]))*$"#) // Error propagation is disabled
        return regexTest(regex: regex, string: username)
    }
    
    
    public func password(_ password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"^[0-9a-zA-Z!@#\$%&\*_\-;.\/\{\}\[\]~()]+$"#)
        return regexTest(regex: regex, string: password)
    }
    
    
    public func email(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: #"^([a-zA-Z0-9]+)([\.\-_][a-zA-Z0-9]+)*[@][a-z]+([.][a-z]+)+$"#)
        return regexTest(regex: regex, string: email)
    }
}
