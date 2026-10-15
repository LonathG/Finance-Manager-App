//
//  Transaction.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct Transaction: Identifiable, Codable {
    public var id: UUID
    public var merchant: String
    public var category: ExpenseCategory
    public var amount: Double
    public var date: Date
    public var paymentMethod: String
    public var note: String?
    public var isScannedReceipt: Bool
    
    public init(
        id: UUID = UUID(),
        merchant: String,
        category: ExpenseCategory,
        amount: Double,
        date: Date = Date(),
        paymentMethod: String = "Card ••4829",
        note: String? = nil,
        isScannedReceipt: Bool = false
    ) {
        self.id = id
        self.merchant = merchant
        self.category = category
        self.amount = amount
        self.date = date
        self.paymentMethod = paymentMethod
        self.note = note
        self.isScannedReceipt = isScannedReceipt
    }
    
    public var formattedDateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "Today, \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return "Yesterday, \(formatter.string(from: date))"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, h:mm a"
            return formatter.string(from: date)
        }
    }
}
