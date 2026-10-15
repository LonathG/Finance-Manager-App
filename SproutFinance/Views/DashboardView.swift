//
//  DashboardView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct DashboardView: View {
    @Environment(FinanceStore.self) private var store
    var onScanTap: () -> Void
    var onAnalyticsTap: () -> Void
    var onAddExpenseTap: () -> Void
    var onProfileTap: () -> Void
    
    @State private var showNotificationsSheet: Bool = false
    
    public init(
        onScanTap: @escaping () -> Void,
        onAnalyticsTap: @escaping () -> Void,
        onAddExpenseTap: @escaping () -> Void,
        onProfileTap: @escaping () -> Void
    ) {
        self.onScanTap = onScanTap
        self.onAnalyticsTap = onAnalyticsTap
        self.onAddExpenseTap = onAddExpenseTap
        self.onProfileTap = onProfileTap
    }
    
    public var body: some View {
        ZStack {
            SproutTheme.surface
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Fixed App Header
                HStack {
                    HStack(spacing: 10) {
                        Image("SproutLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        
                        Text("Dashboard")
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
                
                // Main Scrollable Area
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        // Greeting & Notification Bell
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hello, Alex")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(SproutTheme.textSecondary)
                                
                                Text("Weekly Overview")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(SproutTheme.textPrimary)
                                    .tracking(-0.3)
                            }
                            
                            Spacer()
                            
                            // Floating Circular Notification Button
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                store.hasUnreadNotifications = false
                                showNotificationsSheet = true
                            } label: {
                                ZStack(alignment: .topTrailing) {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 48, height: 48)
                                        .shadow(color: Color(hex: "0F172A").opacity(0.06), radius: 10, x: 0, y: 4)
                                        .overlay(
                                            Image(systemName: "bell.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(SproutTheme.textSecondary)
                                        )
                                    
                                    if store.hasUnreadNotifications {
                                        Circle()
                                            .fill(SproutTheme.brand)
                                            .frame(width: 10, height: 10)
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .offset(x: -2, y: 2)
                                    }
                                }
                            }
                        }
                        .padding(.top, 6)
                        
                        // Hero Focal Card: Sprout Garden Allowance
                        ZStack {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color(hex: "0F172A").opacity(0.05), radius: 20, x: 0, y: 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .stroke(SproutTheme.borderIce.opacity(0.6), lineWidth: 1)
                                )
                            
                            // Organic background gradient glow
                            Circle()
                                .fill(SproutTheme.brand.opacity(0.05))
                                .frame(width: 160, height: 160)
                                .offset(x: 100, y: -40)
                                .blur(radius: 20)
                            
                            VStack(alignment: .leading, spacing: 14) {
                                // Status Badge & Day Info
                                HStack {
                                    HStack(spacing: 6) {
                                        Image(systemName: "leaf.fill")
                                            .font(.system(size: 13))
                                            .foregroundColor(SproutTheme.brand)
                                        Text("Remaining Allowance")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(SproutTheme.brand)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(SproutTheme.surfaceContainerHigh)
                                    .clipShape(Capsule())
                                    
                                    Spacer()
                                    
                                    Text("Day \(store.dayOfCycle) of \(store.totalDaysInCycle)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(SproutTheme.textSecondary)
                                        .tracking(0.5)
                                }
                                
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        // Monetary Numerals
                                        Text("$\(String(format: "%.2f", store.remainingAllowance))")
                                            .font(.system(size: 38, weight: .bold, design: .rounded))
                                            .foregroundColor(SproutTheme.textPrimary)
                                            .tracking(-1)
                                            .contentTransition(.numericText())
                                        
                                        Text("of $\(String(format: "%.2f", store.weeklyTarget)) weekly target")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(SproutTheme.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    // Sprout Garden Plant Visual
                                    SproutPlantView(capacityPercentage: store.capacityIntactPercentage)
                                }
                                
                                // Progress Meter
                                VStack(spacing: 8) {
                                    GeometryReader { barGeo in
                                        let capacity = CGFloat(store.capacityIntactPercentage) / 100.0
                                        ZStack(alignment: .leading) {
                                            Capsule()
                                                .fill(SproutTheme.surfaceContainerHigh)
                                                .frame(height: 8)
                                            
                                            Capsule()
                                                .fill(SproutTheme.brand)
                                                .frame(width: max(16, barGeo.size.width * min(1.0, capacity)), height: 8)
                                                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: store.capacityIntactPercentage)
                                        }
                                    }
                                    .frame(height: 8)
                                    
                                    HStack {
                                        Text("\(store.capacityIntactPercentage)% capacity intact")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(SproutTheme.textSecondary)
                                        
                                        Spacer()
                                        
                                        Text("$\(String(format: "%.0f", store.totalSpent)) spent")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(SproutTheme.brand)
                                    }
                                }
                                .padding(.top, 4)
                            }
                            .padding(22)
                        }
                        
                        // Tactical Action Pill Dock
                        HStack(spacing: 12) {
                            // 1. Add Expense Pill
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                onAddExpenseTap()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 15, weight: .bold))
                                    Text("Add Expense")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(SproutTheme.brand)
                                .clipShape(Capsule())
                                .shadow(color: SproutTheme.glowBrand, radius: 12, x: 0, y: 4)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            
                            // 2. Scan Receipt Pill (Camera)
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                onScanTap()
                            } label: {
                                Circle()
                                    .fill(SproutTheme.textPrimary)
                                    .frame(width: 50, height: 50)
                                    .shadow(color: Color(hex: "0F172A").opacity(0.14), radius: 10, x: 0, y: 4)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    )
                            }
                            .buttonStyle(ScaleButtonStyle())
                            
                            // 3. Analytics Pill
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                onAnalyticsTap()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "chart.xyaxis.line")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Analytics")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(SproutTheme.brand)
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(SproutTheme.borderIce, lineWidth: 1)
                                )
                                .shadow(color: SproutTheme.cardShadow, radius: 8, x: 0, y: 2)
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                        
                        // Active Categories Section
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Active Categories")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(SproutTheme.textPrimary)
                                
                                Spacer()
                                
                                Button {
                                    onAnalyticsTap()
                                } label: {
                                    HStack(spacing: 2) {
                                        Text("View all")
                                            .font(.system(size: 13, weight: .semibold))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 11, weight: .semibold))
                                    }
                                    .foregroundColor(SproutTheme.brand)
                                }
                            }
                            
                            // Bento Category Cards
                            VStack(spacing: 12) {
                                ForEach(store.categories) { cat in
                                    CategoryBentoCard(category: cat)
                                }
                            }
                        }
                        
                        // Garden Sprout Daily Micro-Tip Delight Card
                        HStack(spacing: 14) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                                .shadow(color: SproutTheme.cardShadow, radius: 4, x: 0, y: 2)
                                .overlay(
                                    Image(systemName: "leaf.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(SproutTheme.sproutGreen)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sprout Healthy")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(SproutTheme.textPrimary)
                                
                                Text("You are $42 ahead of pace this week. Keep thriving!")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(SproutTheme.textSecondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(14)
                        .background(SproutTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120) // Space for floating tab bar
                }
            }
        }
        .sheet(isPresented: $showNotificationsSheet) {
            NotificationsSheetView()
                .presentationDetents([.medium])
        }
    }
}

// MARK: - Category Bento Card Component
struct CategoryBentoCard: View {
    let category: BudgetCategory
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                // Category Icon
                Circle()
                    .fill(category.category.backgroundTint)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: category.category.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(category.category.color)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(SproutTheme.textPrimary)
                    
                    Text(category.subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(SproutTheme.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("$\(String(format: "%.2f", category.spent))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(SproutTheme.textPrimary)
                    
                    Text("of $\(String(format: "%.0f", category.allocated))")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(SproutTheme.textSecondary)
                }
            }
            
            // Progress Line
            HStack(spacing: 10) {
                GeometryReader { lineGeo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(SproutTheme.surfaceContainerHigh)
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(category.category.color)
                            .frame(width: max(8, lineGeo.size.width * CGFloat(category.spentPercentage)), height: 6)
                    }
                }
                .frame(height: 6)
                
                Text("\(Int(category.spentPercentage * 100))%")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(SproutTheme.textSecondary)
                    .frame(width: 38, alignment: .trailing)
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: SproutTheme.cardShadow, radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(SproutTheme.borderIce.opacity(0.6), lineWidth: 1)
        )
    }
}

// MARK: - Notifications Sheet
struct NotificationsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Recent Alerts") {
                    HStack(spacing: 12) {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(SproutTheme.sproutGreen)
                        VStack(alignment: .leading) {
                            Text("Weekly Pace Record")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Your grocery budget is 18% under projected spending.")
                                .font(.system(size: 13))
                                .foregroundColor(SproutTheme.textSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .foregroundColor(SproutTheme.brand)
                        VStack(alignment: .leading) {
                            Text("Receipt Auto-Categorized")
                                .font(.system(size: 15, weight: .semibold))
                            Text("Whole Foods receipt ($42.80) was processed via Vision OCR.")
                                .font(.system(size: 13))
                                .foregroundColor(SproutTheme.textSecondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
