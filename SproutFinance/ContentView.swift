//
//  ContentView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public enum RootNavigationState {
    case splash
    case onboarding
    case login
    case main
}

struct ContentView: View {
    @State private var store = FinanceStore()
    @State private var navState: RootNavigationState = .splash
    @State private var selectedTab: AppTab = .garden
    
    // Sheets
    @State private var showScannerSheet: Bool = false
    @State private var showAddExpenseSheet: Bool = false
    @State private var showProfileSheet: Bool = false
    
    var body: some View {
        ZStack {
            switch navState {
            case .splash:
                SplashView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        navState = .onboarding
                    }
                }
                .transition(.opacity)
                
            case .onboarding:
                OnboardingView(
                    onGetStarted: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            navState = .login
                        }
                    },
                    onSkip: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            navState = .login
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
            case .login:
                LoginView(
                    onLoginSuccess: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            navState = .main
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            navState = .onboarding
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                
            case .main:
                mainAppContainer
                    .transition(.opacity)
            }
        }
        .environment(store)
        .fullScreenCover(isPresented: $showScannerSheet) {
            ReceiptScannerView()
                .environment(store)
        }
        .sheet(isPresented: $showAddExpenseSheet) {
            AddExpenseSheet()
                .environment(store)
        }
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
                .environment(store)
        }
    }
    
    // MARK: - Main App Container with Floating Tab Bar
    private var mainAppContainer: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .garden:
                    DashboardView(
                        onScanTap: { showScannerSheet = true },
                        onAnalyticsTap: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedTab = .analytics
                            }
                        },
                        onAddExpenseTap: { showAddExpenseSheet = true },
                        onProfileTap: { showProfileSheet = true }
                    )
                case .analytics:
                    WeeklyAnalyticsView(
                        onProfileTap: { showProfileSheet = true }
                    )
                case .scan:
                    // Handled via modal, but fallback to dashboard
                    DashboardView(
                        onScanTap: { showScannerSheet = true },
                        onAnalyticsTap: { selectedTab = .analytics },
                        onAddExpenseTap: { showAddExpenseSheet = true },
                        onProfileTap: { showProfileSheet = true }
                    )
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Floating Navigation Capsule Dock
            FloatingTabBar(
                selectedTab: $selectedTab,
                onScanTap: {
                    showScannerSheet = true
                }
            )
            .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
