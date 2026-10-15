//
//  WeeklyAnalyticsView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct WeeklyAnalyticsView: View {
    @Environment(FinanceStore.self) private var store
    var onProfileTap: () -> Void
    
    @State private var selectedTimeframe: TimeframeFilter = .thisWeek
    @State private var selectedTransaction: Transaction? = nil
    @State private var showAllTransactionsSheet: Bool = false
    
    public init(onProfileTap: @escaping () -> Void) {
        self.onProfileTap = onProfileTap
    }
    
    public var body: some View {
        ZStack {
            SproutTheme.surface
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed Header
                HStack {
                    HStack(spacing: 10) {
                        Image("SproutLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        
                        Text("Weekly Analytics")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(SproutTheme.textPrimary)
                    }
                    
                    Spacer()
                    
                    Button {
                        onProfileTap()
                    } label: {
                        Circle()
                            .fill(SproutTheme.brandDark)
                            .frame(width: 34, height: 34)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.85))
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.04))
                        .frame(height: 1),
                    alignment: .bottom
                )
                
                // Main Scrollable Body
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title & Status Chip Row
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Weekly Trends")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(SproutTheme.textPrimary)
                                    .tracking(-0.3)
                                
                                Text(selectedTimeframe == .thisWeek ? "Oct 9 — Oct 15, 2026" : "Oct 2 — Oct 8, 2026")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(SproutTheme.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Sprout Status Mini Chip
                            HStack(spacing: 6) {
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(SproutTheme.brand)
                                Text("Thriving")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(SproutTheme.brand)
                                    .tracking(0.5)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(SproutTheme.surfaceContainerHigh)
                            .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                        
                        // Segmented Filter Pill Dock
                        HStack(spacing: 4) {
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selectedTimeframe = .thisWeek
                                }
                            } label: {
                                Text("This Week")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedTimeframe == .thisWeek ? .white : SproutTheme.textSecondary)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 8)
                                    .background {
                                        if selectedTimeframe == .thisWeek {
                                            Capsule()
                                                .fill(SproutTheme.brand)
                                                .shadow(color: SproutTheme.glowBrand, radius: 8, x: 0, y: 2)
                                        }
                                    }
                            }
                            
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    selectedTimeframe = .lastWeek
                                }
                            } label: {
                                Text("Last Week")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(selectedTimeframe == .lastWeek ? .white : SproutTheme.textSecondary)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 8)
                                    .background {
                                        if selectedTimeframe == .lastWeek {
                                            Capsule()
                                                .fill(SproutTheme.brand)
                                                .shadow(color: SproutTheme.glowBrand, radius: 8, x: 0, y: 2)
                                        }
                                    }
                            }
                        }
                        .padding(4)
                        .background(SproutTheme.surfaceContainerHigh)
                        .clipShape(Capsule())
                        
                        // Visual Chart Card
                        VStack(alignment: .leading, spacing: 14) {
                            // Upper Tier Metrics
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("TOTAL SPENT")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(SproutTheme.textSecondary)
                                        .tracking(1)
                                    
                                    Text(selectedTimeframe == .thisWeek ? "$\(String(format: "%.2f", store.totalSpent))" : "$310.50")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(SproutTheme.textPrimary)
                                        .tracking(-0.5)
                                        .contentTransition(.numericText())
                                }
                                
                                Spacer()
                                
                                // Pace Indicator Badge
                                if selectedTimeframe == .thisWeek {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.down")
                                            .font(.system(size: 11, weight: .bold))
                                        Text("+$45 under pace")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .foregroundColor(SproutTheme.brand)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(SproutTheme.surfaceContainerHigh)
                                    .clipShape(Capsule())
                                } else {
                                    HStack(spacing: 4) {
                                        Image(systemName: "arrow.up")
                                            .font(.system(size: 11, weight: .bold))
                                        Text("-$18 over budget")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .foregroundColor(SproutTheme.coral)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(SproutTheme.coralLight)
                                    .clipShape(Capsule())
                                }
                            }
                            
                            // Bezier Curve Area Chart
                            SparklineChartView(isThisWeek: selectedTimeframe == .thisWeek)
                                .padding(.top, 6)
                            
                            // Micro Insight Pill Footer
                            HStack {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(SproutTheme.brand)
                                        .frame(width: 7, height: 7)
                                    
                                    HStack(spacing: 3) {
                                        Text("Average daily budget:")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(SproutTheme.textSecondary)
                                        Text(selectedTimeframe == .thisWeek ? "$31.42" : "$44.35")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(SproutTheme.textPrimary)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "info.circle")
                                    .font(.system(size: 14))
                                    .foregroundColor(SproutTheme.textSecondary)
                            }
                            .padding(.top, 6)
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: SproutTheme.cardShadow, radius: 14, x: 0, y: 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(SproutTheme.borderIce.opacity(0.6), lineWidth: 1)
                        )
                        
                        // Recent Activity Feed
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Recent Activity")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(SproutTheme.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    showAllTransactionsSheet = true
                                } label: {
                                    Text("See All")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(SproutTheme.brand)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                ForEach(store.transactions.prefix(5)) { tx in
                                    Button {
                                        selectedTransaction = tx
                                    } label: {
                                        TransactionFeedRow(transaction: tx)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        // Delight Moment / Financial Health Tip Card
                        HStack(spacing: 14) {
                            Circle()
                                .fill(SproutTheme.surfaceContainerHigh)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(SproutTheme.brand)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Weekly Sprout Milestone")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(SproutTheme.textPrimary)
                                
                                Text("You saved 18% more on coffee outings this week!")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(SproutTheme.textSecondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(SproutTheme.textSecondary)
                        }
                        .padding(16)
                        .background(SproutTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) // Tab bar inset
                }
            }
        }
        .sheet(item: $selectedTransaction) { tx in
            TransactionDetailSheet(transaction: tx)
        }
        .sheet(isPresented: $showAllTransactionsSheet) {
            AllTransactionsSheet()
        }
    }
}

// MARK: - Transaction Feed Row
struct TransactionFeedRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(SproutTheme.surfaceContainerHigh)
                .frame(width: 46, height: 46)
                .overlay(
                    Image(systemName: transaction.category.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(SproutTheme.brand)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(transaction.merchant)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(SproutTheme.textPrimary)
                    
                    if transaction.isScannedReceipt {
                        Image(systemName: "doc.viewfinder.fill")
                            .font(.system(size: 11))
                            .foregroundColor(SproutTheme.brand)
                    }
                }
                
                Text("\(transaction.formattedDateString) • \(transaction.category.rawValue)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(SproutTheme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("-$\(String(format: "%.2f", transaction.amount))")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(SproutTheme.textPrimary)
                
                Text(transaction.paymentMethod)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(SproutTheme.textSecondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: SproutTheme.cardShadow, radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(SproutTheme.borderIce.opacity(0.6), lineWidth: 1)
        )
    }
}

// MARK: - Transaction Detail Sheet
struct TransactionDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let transaction: Transaction
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header Amount
                VStack(spacing: 8) {
                    Circle()
                        .fill(SproutTheme.surfaceContainerHigh)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: transaction.category.icon)
                                .font(.system(size: 26))
                                .foregroundColor(SproutTheme.brand)
                        )
                    
                    Text(transaction.merchant)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Text("-$\(String(format: "%.2f", transaction.amount))")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(SproutTheme.textPrimary)
                }
                .padding(.top, 16)
                
                List {
                    Section("Metadata") {
                        LabeledContent("Category", value: transaction.category.rawValue)
                        LabeledContent("Date", value: transaction.formattedDateString)
                        LabeledContent("Payment Method", value: transaction.paymentMethod)
                        if let note = transaction.note {
                            LabeledContent("Note", value: note)
                        }
                        LabeledContent("Source", value: transaction.isScannedReceipt ? "Vision OCR Scanner" : "Manual Entry")
                    }
                }
            }
            .navigationTitle("Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - All Transactions Sheet
struct AllTransactionsSheet: View {
    @Environment(FinanceStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.transactions) { tx in
                    TransactionFeedRow(transaction: tx)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .onDelete { offsets in
                    store.deleteTransaction(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Transaction History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
