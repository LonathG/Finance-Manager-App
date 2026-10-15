//
//  AddExpenseSheet.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct AddExpenseSheet: View {
    @Environment(FinanceStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var merchant: String = ""
    @State private var amountString: String = ""
    @State private var selectedCategory: ExpenseCategory = .groceries
    @State private var paymentMethod: String = "Apple Pay (•• 4821)"
    @State private var note: String = ""
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Amount & Merchant") {
                    HStack(alignment: .firstTextBaseline) {
                        Text("$")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(SproutTheme.brand)
                        
                        TextField("0.00", text: $amountString)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                    }
                    .padding(.vertical, 4)
                    
                    TextField("Merchant (e.g. Trader Joe's)", text: $merchant)
                }
                
                Section("Category") {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                }
                
                Section("Details") {
                    Picker("Payment Method", selection: $paymentMethod) {
                        Text("Apple Pay (•• 4821)").tag("Apple Pay (•• 4821)")
                        Text("Card ••4829").tag("Card ••4829")
                        Text("Cash").tag("Cash")
                        Text("Bank Transfer").tag("Bank Transfer")
                    }
                    
                    TextField("Optional Note", text: $note)
                }
                
                Section {
                    Button {
                        saveExpense()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save Expense")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(SproutTheme.brand)
                    .disabled(amountValue <= 0 || merchant.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var amountValue: Double {
        Double(amountString) ?? 0.0
    }
    
    private func saveExpense() {
        guard amountValue > 0 else { return }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        store.addTransaction(
            merchant: merchant.isEmpty ? selectedCategory.rawValue : merchant,
            amount: amountValue,
            category: selectedCategory,
            paymentMethod: paymentMethod,
            note: note.isEmpty ? nil : note,
            isScanned: false
        )
        
        dismiss()
    }
}
