//
//  FloatingTabBar.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public enum AppTab: Int, CaseIterable {
    case garden = 0
    case analytics = 1
    case scan = 2
    case profile = 3
    
    public var title: String {
        switch self {
        case .garden: return "Garden"
        case .analytics: return "Analytics"
        case .scan: return "Scan"
        case .profile: return "Profile"
        }
    }
    
    public var icon: String {
        switch self {
        case .garden: return "leaf.fill"
        case .analytics: return "chart.xyaxis.line"
        case .scan: return "doc.viewfinder.fill"
        case .profile: return "person.fill"
        }
    }
}

public struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab
    var onScanTap: () -> Void
    
    public init(selectedTab: Binding<AppTab>, onScanTap: @escaping () -> Void) {
        self._selectedTab = selectedTab
        self.onScanTap = onScanTap
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    
                    if tab == .scan {
                        onScanTap()
                    } else {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedTab = tab
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 17, weight: .semibold))
                        
                        if selectedTab == tab && tab != .scan {
                            Text(tab.title)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                                .fixedSize()
                                .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .foregroundColor(selectedTab == tab && tab != .scan ? SproutTheme.brand : SproutTheme.textSecondary)
                    .padding(.horizontal, selectedTab == tab && tab != .scan ? 12 : 10)
                    .padding(.vertical, 8)
                    .background {
                        if selectedTab == tab && tab != .scan {
                            Capsule()
                                .fill(SproutTheme.surfaceContainerHigh)
                        } else if tab == .scan {
                            Capsule()
                                .fill(SproutTheme.textPrimary)
                        }
                    }
                    .foregroundColor(tab == .scan ? .white : (selectedTab == tab ? SproutTheme.brand : SproutTheme.textSecondary))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(Color.white.opacity(0.92))
                .shadow(color: Color(hex: "0F172A").opacity(0.10), radius: 18, x: 0, y: 8)
                .overlay(
                    Capsule()
                        .stroke(SproutTheme.borderIce.opacity(0.8), lineWidth: 1)
                )
        }
        .padding(.bottom, 8)
    }
}
