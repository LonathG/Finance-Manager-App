//
//  SplashView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct SplashView: View {
    var onComplete: () -> Void
    
    @State private var logoAppeared: Bool = false
    @State private var dotPhase: Int = 0
    
    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            SproutTheme.surface
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Brand Centerpiece
                VStack(spacing: 20) {
                    // Logo Icon with ambient glow
                    ZStack {
                        Circle()
                            .fill(SproutTheme.brand.opacity(0.12))
                            .frame(width: 140, height: 140)
                            .blur(radius: 20)
                            .scaleEffect(logoAppeared ? 1.05 : 0.9)
                        
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 88, height: 88)
                            .shadow(color: SproutTheme.brand.opacity(0.15), radius: 20, x: 0, y: 10)
                            .overlay(
                                Image("SproutLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(14)
                            )
                    }
                    .scaleEffect(logoAppeared ? 1.0 : 0.95)
                    .opacity(logoAppeared ? 1.0 : 0.0)
                    
                    VStack(spacing: 8) {
                        Text("SproutFinance")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(SproutTheme.textPrimary)
                            .tracking(-0.5)
                        
                        Text("PROACTIVE MICRO-BUDGETING")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(SproutTheme.textSecondary)
                            .tracking(2.5)
                    }
                    .opacity(logoAppeared ? 1.0 : 0.0)
                    .offset(y: logoAppeared ? 0 : 12)
                }
                
                Spacer()
                
                // Bottom Sync & Bouncing Dots
                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(SproutTheme.brand)
                            .frame(width: 6, height: 6)
                            .offset(y: dotPhase == 0 ? -6 : 0)
                        
                        Circle()
                            .fill(SproutTheme.brand)
                            .frame(width: 6, height: 6)
                            .offset(y: dotPhase == 1 ? -6 : 0)
                        
                        Circle()
                            .fill(SproutTheme.brand)
                            .frame(width: 6, height: 6)
                            .offset(y: dotPhase == 2 ? -6 : 0)
                    }
                    .animation(.easeInOut(duration: 0.35).repeatForever(autoreverses: true), value: dotPhase)
                    
                    Text("ENCRYPTED FINANCIAL SYNC")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(SproutTheme.textSecondary)
                        .tracking(1.5)
                }
                .padding(.bottom, 48)
            }
        }
        .onTapGesture {
            onComplete()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                logoAppeared = true
            }
            
            // Animate dots
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                withAnimation {
                    dotPhase = (dotPhase + 1) % 3
                }
            }
            
            // Auto-advance
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation {
                    onComplete()
                }
            }
        }
    }
}
