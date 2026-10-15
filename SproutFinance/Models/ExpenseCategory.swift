//
//  ExpenseCategory.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case groceries = "Groceries"
    case dining = "Dining"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case health = "Health"
    case bills = "Bills"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .groceries: return "cart.fill"
        case .dining: return "cup.and.saucer.fill"
        case .transport: return "tram.fill"
        case .shopping: return "bag.fill"
        case .entertainment: return "popcorn.fill"
        case .health: return "heart.fill"
        case .bills: return "bolt.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .groceries: return SproutTheme.brand
        case .dining: return Color(hex: "485466")
        case .transport: return SproutTheme.sproutGreen
        case .shopping: return Color(hex: "8E111C")
        case .entertainment: return Color(hex: "B02C31")
        case .health: return Color(hex: "006D35")
        case .bills: return Color(hex: "565E74")
        }
    }
    
    public var backgroundTint: Color {
        switch self {
        case .groceries: return SproutTheme.surfaceContainerHigh
        case .dining: return Color(hex: "DAE2FD")
        case .transport: return SproutTheme.sproutGreenLight
        case .shopping: return Color(hex: "FFDAD7")
        case .entertainment: return Color(hex: "FFDAD6")
        case .health: return Color(hex: "D5E3FC")
        case .bills: return Color(hex: "EFF4FF")
        }
    }
}
