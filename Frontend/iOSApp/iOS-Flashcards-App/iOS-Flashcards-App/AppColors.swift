//
//  AppColors.swift
//  iOS-Flashcards-App
//
//  Created by Neal Archival on 7/28/22.
//

import SwiftUI

extension Color {
    public static let indigoDye = Color("IndigoDye")
    public static let queenBlue = Color("QueenBlue")
    public static let carolinaBlue = Color("CarolinaBlue")
    public static let babyBlue = Color("babyBlue")
    public static let skyBlue = Color("SkyBlueCrayola")
    public static let appWhite = Color("AppWhite")
    
    // Custom initializer than accepts a hexadecimal
    init(hex: Int, opacity: Double = 1.0) {
        // Note: 0xff = 255
        let red = Double((hex & 0xff000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 4) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue)
    }
}
