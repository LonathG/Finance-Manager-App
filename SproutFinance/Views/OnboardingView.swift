//
//  OnboardingView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct OnboardingView: View {
    var onGetStarted: () -> Void
    var onSkip: () -> Void
    
    @State private var laserOffset: CGFloat = -40
    @State private var floatingAmountOffset: CGFloat = 0
    @State private var currentStep: Int = 1
    
    public init(onGetStarted: @escaping () -> Void, onSkip: @escaping () -> Void) {
        self.onGetStarted = onGetStarted
        self.onSkip = onSkip
    }
    
    public var body: some View {
        ZStack {
            SproutTheme.surface
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer(minLength: 16)
                
                // Hero White Squircle Card (Corner Radius 32)
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: SproutTheme.cardShadow, radius: 24, x: 0, y: 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(SproutTheme.borderIce.opacity(0.8), lineWidth: 1)
                        )
                    
                    // Decorative interior glow
                    Circle()
                        .fill(SproutTheme.brand.opacity(0.06))
                        .frame(width: 180, height: 180)
                        .offset(x: 70, y: -60)
                        .blur(radius: 25)
                    
                    // Central Composition
                    VStack {
                        ZStack {
                            // Target Reticles
                            Image(systemName: "viewfinder")
                                .font(.system(size: 26, weight: .light))
                                .foregroundColor(SproutTheme.brand.opacity(0.4))
                                .offset(x: -95, y: -75)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 22))
                                .foregroundColor(SproutTheme.brand.opacity(0.35))
                                .offset(x: 95, y: 70)
                            
                            // Minimal Receipt Container
                            VStack(alignment: .leading, spacing: 10) {
                                // Receipt Header
                                HStack {
                                    Circle()
                                        .fill(SproutTheme.brand.opacity(0.12))
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "receipt")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(SproutTheme.brand)
                                        )
                                    
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest)
                                        .frame(width: 64, height: 8)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 4)
                                
                                // Wire Lines
                                HStack {
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest)
                                        .frame(width: 90, height: 8)
                                    Spacer()
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest)
                                        .frame(width: 28, height: 8)
                                }
                                
                                HStack {
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest.opacity(0.8))
                                        .frame(width: 60, height: 7)
                                    Spacer()
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest.opacity(0.8))
                                        .frame(width: 22, height: 7)
                                }
                                
                                HStack {
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest.opacity(0.6))
                                        .frame(width: 76, height: 7)
                                    Spacer()
                                    Capsule()
                                        .fill(SproutTheme.surfaceContainerHighest.opacity(0.6))
                                        .frame(width: 26, height: 7)
                                }
                                
                                // Dashed cut line
                                HStack(spacing: 5) {
                                    ForEach(0..<6, id: \.self) { _ in
                                        Capsule()
                                            .fill(SproutTheme.surfaceContainerHighest)
                                            .frame(height: 2)
                                    }
                                }
                                .padding(.vertical, 4)
                                
                                // Total wire
                                HStack {
                                    Capsule()
                                        .fill(SproutTheme.textSecondary.opacity(0.4))
                                        .frame(width: 44, height: 10)
                                    Spacer()
                                    Capsule()
                                        .fill(SproutTheme.brand.opacity(0.5))
                                        .frame(width: 52, height: 10)
                                }
                            }
                            .padding(18)
                            .frame(width: 200)
                            .background(SproutTheme.surfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: Color(hex: "0D1C2E").opacity(0.06), radius: 14, x: 0, y: 6)
                            
                            // Dynamic Laser Scan Line
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, SproutTheme.brand, .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 196, height: 2)
                                .shadow(color: SproutTheme.brand, radius: 6, x: 0, y: 0)
                                .offset(y: laserOffset)
                            
                            // Floating Pill 1: Amount $42.80
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(SproutTheme.sproutGreen)
                                    .frame(width: 8, height: 8)
                                Text("$42.80")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(SproutTheme.textPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                            .offset(x: 65, y: -55 + floatingAmountOffset)
                            
                            // Floating Pill 2: Category Groceries
                            HStack(spacing: 6) {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(SproutTheme.brand)
                                Text("Groceries")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(SproutTheme.textSecondary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                            .offset(x: -60, y: 60)
                        }
                    }
                    .frame(height: 250)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 310)
                .padding(.horizontal, 24)
                
                // Typographic Narrative
                VStack(spacing: 12) {
                    Text("Smart Scan. Effortless Habit.")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(SproutTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        .tracking(-0.3)
                    
                    Text("Capture any receipt instantly with on-device Vision OCR. Track weekly limits before overspending happens.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(SproutTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 28)
                }
                
                // Stepper Dots
                HStack(spacing: 8) {
                    Capsule()
                        .fill(currentStep == 0 ? SproutTheme.brand : SproutTheme.surfaceContainerHigh)
                        .frame(width: currentStep == 0 ? 24 : 8, height: 8)
                    
                    Capsule()
                        .fill(currentStep == 1 ? SproutTheme.brand : SproutTheme.surfaceContainerHigh)
                        .frame(width: currentStep == 1 ? 24 : 8, height: 8)
                }
                .animation(.spring(), value: currentStep)
                
                Spacer()
                
                // Actions Stack
                VStack(spacing: 12) {
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        onGetStarted()
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(SproutTheme.brand)
                            .clipShape(Capsule())
                            .shadow(color: SproutTheme.glowBrand, radius: 16, x: 0, y: 6)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button {
                        onSkip()
                    } label: {
                        Text("Skip")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(SproutTheme.textSecondary)
                            .frame(height: 36)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            // Animate laser scanner up and down
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                laserOffset = 45
            }
            
            // Subtle floating badge bounce
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                floatingAmountOffset = -6
            }
        }
    }
}

// Micro-interaction Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
