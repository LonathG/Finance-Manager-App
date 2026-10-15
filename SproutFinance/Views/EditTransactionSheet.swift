//
//  EditTransactionSheet.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct EditTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var merchant: String
    @Binding var amount: Double
    @Binding var category: ExpenseCategory
    @Binding var paymentMethod: String
    
    @State private var amountString: String = ""
    
    public init(merchant: Binding<String>, amount: Binding<Double>, category: Binding<ExpenseCategory>, paymentMethod: Binding<String>) {
        self._merchant = merchant
        self._amount = amount
        self._category = category
        self._paymentMethod = paymentMethod
        self._amountString = State(initialValue: String(format: "%.2f", amount.wrappedValue))
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Transaction Details") {
                    TextField("Merchant Name", text: $merchant)
                    
                    HStack {
                        Text("$")
                            .foregroundColor(SproutTheme.textSecondary)
                        TextField("0.00", text: $amountString)
                            .keyboardType(.decimalPad)
                            .onChange(of: amountString) { _, newVal in
                                if let val = Double(newVal) {
                                    amount = val
                                }
                            }
                    }
                }
                
                Section("Classification") {
                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    
                    TextField("Payment Method", text: $paymentMethod)
                }
            }
            .navigationTitle("Edit Scanned Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if let val = Double(amountString) {
                            amount = val
                        }
                        dismiss()
                    }
                    .font(.body.bold())
                    .foregroundColor(SproutTheme.brand)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
