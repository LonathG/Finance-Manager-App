//
//  ProfileView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct ProfileView: View {
    @Environment(FinanceStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var weeklyBudgetInput: Double = 1000.00
    @State private var currency: String = "USD ($)"
    @State private var faceIDEnabled: Bool = true
    @State private var notificationsEnabled: Bool = true
    @State private var showSavedAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                // Profile Header Card
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(SproutTheme.brand)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text(store.userName)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(SproutTheme.textPrimary)
                                
                                Text("PRO")
                                    .font(.system(size: 10, weight: .heavy))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(SproutTheme.sproutGreen)
                                    .clipShape(Capsule())
                            }
                            
                            Text(store.userEmail)
                                .font(.system(size: 13))
                                .foregroundColor(SproutTheme.textSecondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                
                // Sprout Garden Health Stats
                Section("Garden Milestones") {
                    HStack {
                        Label("Current Growth", systemImage: "leaf.fill")
                            .foregroundColor(SproutTheme.brand)
                        Spacer()
                        Text(store.plantGrowthStage)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(SproutTheme.sproutGreen)
                    }
                    
                    HStack {
                        Label("Capacity Intact", systemImage: "chart.pie.fill")
                            .foregroundColor(SproutTheme.brand)
                        Spacer()
                        Text("\(store.capacityIntactPercentage)%")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    
                    HStack {
                        Label("Active Envelopes", systemImage: "tray.full.fill")
                            .foregroundColor(SproutTheme.brand)
                        Spacer()
                        Text("\(store.categories.count)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                
                // Budget Allocation
                Section("Budget Configuration") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Weekly Target Goal")
                            Spacer()
                            Text("$\(String(format: "%.0f", store.weeklyTarget))")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(SproutTheme.brand)
                        }
                        
                        Slider(value: $store.weeklyTarget, in: 200...3000, step: 50)
                            .tint(SproutTheme.brand)
                    }
                    .padding(.vertical, 4)
                    
                    Picker("Primary Currency", selection: $currency) {
                        Text("USD ($)").tag("USD ($)")
                        Text("EUR (€)").tag("EUR (€)")
                        Text("GBP (£)").tag("GBP (£)")
                        Text("CAD ($)").tag("CAD ($)")
                    }
                }
                
                // Security & Preferences
                Section("Security & Notifications") {
                    Toggle("Biometric Face ID Access", isOn: $faceIDEnabled)
                        .tint(SproutTheme.brand)
                    
                    Toggle("Smart Spending Alerts", isOn: $notificationsEnabled)
                        .tint(SproutTheme.brand)
                }
                
                // Sign Out
                Section {
                    Button(role: .destructive) {
                        store.isAuthenticated = false
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile & Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .font(.body.bold())
                        .foregroundColor(SproutTheme.brand)
                }
            }
        }
    }
}
