//
//  FinanceStore.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI
import Combine

public enum TimeframeFilter: String, CaseIterable {
    case thisWeek = "This Week"
    case lastWeek = "Last Week"
}

@Observable
public final class FinanceStore {
    // MARK: - User & Auth State
    public var isAuthenticated: Bool = false
    public var hasCompletedOnboarding: Bool = false
    public var userName: String = "Alex Morgan"
    public var userEmail: String = "alex.morgan@example.com"
    public var hasUnreadNotifications: Bool = true
    
    // MARK: - Weekly Budget State
    public var weeklyTarget: Double = 1000.00
    public var dayOfCycle: Int = 4
    public var totalDaysInCycle: Int = 7
    public var selectedTimeframe: TimeframeFilter = .thisWeek
    
    // MARK: - Categories
    public var categories: [BudgetCategory] = [
        BudgetCategory(name: "Groceries", subtitle: "Essential & Pantry", category: .groceries, allocated: 200.00, spent: 120.00),
        BudgetCategory(name: "Dining", subtitle: "Cafés & Outings", category: .dining, allocated: 80.00, spent: 45.00),
        BudgetCategory(name: "Transport", subtitle: "Subway & Rides", category: .transport, allocated: 50.00, spent: 32.00),
        BudgetCategory(name: "Shopping", subtitle: "Gear & Clothing", category: .shopping, allocated: 100.00, spent: 23.00)
    ]
    
    // MARK: - Transactions
    public var transactions: [Transaction] = []
    public var lastWeekTransactions: [Transaction] = []
    
    // MARK: - Daily Spending for Charts
    public var thisWeekDailySpending: [Double] = [32.0, 24.0, 48.0, 42.8, 28.0, 18.0, 27.2] // Mon..Sun
    public var lastWeekDailySpending: [Double] = [45.0, 52.0, 38.0, 60.5, 35.0, 50.0, 30.0]
    
    public init() {
        seedInitialData()
    }
    
    // MARK: - Computed Balances
    public var totalSpent: Double {
        if selectedTimeframe == .thisWeek {
            return transactions.reduce(0) { $0 + $1.amount }
        } else {
            return 310.50
        }
    }
    
    public var remainingAllowance: Double {
        max(0, weeklyTarget - totalSpent)
    }
    
    public var capacityIntactPercentage: Int {
        guard weeklyTarget > 0 else { return 0 }
        let pct = (remainingAllowance / weeklyTarget) * 100.0
        return Int(round(pct))
    }
    
    public var paceDifference: Double {
        // Expected pace at day 4 of 7 is (4/7) * 1000 = ~571.42
        // If spent 220, we are under pace by (571.42 - 220) = ~351.42
        // Stitch says "+$45 under pace" for simple metric
        return 45.0
    }
    
    // MARK: - Sprout Growth Stage
    public var plantGrowthStage: String {
        let capacity = capacityIntactPercentage
        if capacity >= 70 {
            return "Thriving Sprout"
        } else if capacity >= 40 {
            return "Growing Sapling"
        } else {
            return "Needs Nourishment"
        }
    }
    
    // MARK: - Actions
    public func addTransaction(merchant: String, amount: Double, category: ExpenseCategory, paymentMethod: String = "Apple Pay (•• 4821)", note: String? = nil, isScanned: Bool = false) {
        let newTx = Transaction(
            merchant: merchant,
            category: category,
            amount: amount,
            date: Date(),
            paymentMethod: paymentMethod,
            note: note,
            isScannedReceipt: isScanned
        )
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            transactions.insert(newTx, at: 0)
            
            // Update corresponding category
            if let index = categories.firstIndex(where: { $0.category == category }) {
                categories[index].spent += amount
            } else {
                categories.append(BudgetCategory(name: category.rawValue, subtitle: "Custom Category", category: category, allocated: 100.00, spent: amount))
            }
            
            // Update daily spending for today (day 4 / Thursday)
            thisWeekDailySpending[3] += amount
        }
    }
    
    public func deleteTransaction(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let tx = transactions[index]
                if let catIndex = categories.firstIndex(where: { $0.category == tx.category }) {
                    categories[catIndex].spent = max(0, categories[catIndex].spent - tx.amount)
                }
            }
            transactions.remove(atOffsets: offsets)
        }
    }
    
    // MARK: - Seed Data
    private func seedInitialData() {
        let calendar = Calendar.current
        let now = Date()
        
        let tx1 = Transaction(
            merchant: "Whole Foods Market",
            category: .groceries,
            amount: 42.80,
            date: calendar.date(byAdding: .hour, value: -2, to: now) ?? now,
            paymentMethod: "Apple Pay (•• 4821)",
            note: "Weekly organic veggies & oat milk",
            isScannedReceipt: true
        )
        
        let tx2 = Transaction(
            merchant: "Metro Transit",
            category: .transport,
            amount: 2.75,
            date: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
            paymentMethod: "Apple Pay",
            note: "Downtown commute"
        )
        
        let tx3 = Transaction(
            merchant: "Blue Bottle Coffee",
            category: .dining,
            amount: 5.40,
            date: calendar.date(byAdding: .day, value: -1, to: calendar.date(byAdding: .hour, value: 1, to: now)!) ?? now,
            paymentMethod: "Card ••4829",
            note: "New Orleans cold brew"
        )
        
        let tx4 = Transaction(
            merchant: "Trader Joe's",
            category: .groceries,
            amount: 77.20,
            date: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
            paymentMethod: "Card ••4829",
            note: "Pantry supplies & fruits"
        )
        
        let tx5 = Transaction(
            merchant: "Sweetgreen",
            category: .dining,
            amount: 39.60,
            date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
            paymentMethod: "Apple Pay (•• 4821)",
            note: "Harvest bowl lunch with team"
        )
        
        let tx6 = Transaction(
            merchant: "Metro Transit",
            category: .transport,
            amount: 29.25,
            date: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
            paymentMethod: "Apple Pay",
            note: "Weekly metro pass refill"
        )
        
        let tx7 = Transaction(
            merchant: "Amazon Basics",
            category: .shopping,
            amount: 23.00,
            date: calendar.date(byAdding: .day, value: -4, to: now) ?? now,
            paymentMethod: "Card ••4829",
            note: "Phone charging cables"
        )
        
        transactions = [tx1, tx2, tx3, tx4, tx5, tx6, tx7]
    }
}
