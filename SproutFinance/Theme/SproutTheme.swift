//
//  SproutTheme.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public enum SproutTheme {
    // MARK: - Core Palette Colors
    public static let brand = Color(hex: "2B59FF")               // Royal Cobalt Primary
    public static let brandDark = Color(hex: "003FDD")           // Deep Brand Blue
    public static let sproutGreen = Color(hex: "38B264")         // Sprout Sage Positive
    public static let sproutGreenDark = Color(hex: "006D35")     // Deep Sprout Green
    public static let sproutGreenLight = Color(hex: "EBF8F0")    // Sprout Wash / Tint
    
    // Surfaces & Backgrounds
    public static let background = Color(hex: "EBF2FA")          // Soft Ice Background
    public static let surface = Color(hex: "F8F9FF")             // Surface Bright
    public static let surfaceCard = Color.white                  // Pure White Bento Card
    public static let surfaceSecondary = Color(hex: "EFF4FF")    // Secondary Ice Surface
    public static let surfaceContainerHigh = Color(hex: "DCE8FE")// Tinted Container
    public static let surfaceContainerHighest = Color(hex: "D5E3FC")
    
    // Typography & Ink
    public static let textPrimary = Color(hex: "0F172A")         // Midnight Ink
    public static let textSecondary = Color(hex: "64748B")       // Slate Subtitle
    public static let textTertiary = Color(hex: "94A3B8")        // Muted Caption
    
    // Accents & Functional
    public static let borderIce = Color(hex: "DCE8FE")           // Delicate Hairline Border
    public static let coral = Color(hex: "E55353")               // Budget Warning / Expense
    public static let coralLight = Color(hex: "FDF2F2")          // Coral Wash
    public static let warningYellow = Color(hex: "FBBC05")       // Amber Alert
    
    // MARK: - Shadows
    public static let cardShadow = Color(hex: "0F172A").opacity(0.04)
    public static let floatingShadow = Color(hex: "0F172A").opacity(0.08)
    public static let glowBrand = Color(hex: "2B59FF").opacity(0.28)
}

// MARK: - Color Hex Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
