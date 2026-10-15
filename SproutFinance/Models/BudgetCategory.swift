//
//  BudgetCategory.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct BudgetCategory: Identifiable, Codable {
    public var id: String
    public var name: String
    public var subtitle: String
    public var category: ExpenseCategory
    public var allocated: Double
    public var spent: Double
    
    public var percentageIntact: Double {
        guard allocated > 0 else { return 0 }
        let remaining = max(0, allocated - spent)
        return (remaining / allocated) * 100
    }
    
    public var spentPercentage: Double {
        guard allocated > 0 else { return 0 }
        return min(1.0, spent / allocated)
    }
    
    public init(id: String = UUID().uuidString, name: String, subtitle: String, category: ExpenseCategory, allocated: Double, spent: Double) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.category = category
        self.allocated = allocated
        self.spent = spent
    }
}
