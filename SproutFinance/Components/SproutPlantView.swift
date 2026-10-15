//
//  SproutPlantView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct SproutPlantView: View {
    public var capacityPercentage: Int
    @State private var isAnimating: Bool = false
    
    public init(capacityPercentage: Int) {
        self.capacityPercentage = capacityPercentage
    }
    
    public var body: some View {
        ZStack {
            // Soft glowing pulse behind sprout
            Circle()
                .fill(SproutTheme.sproutGreen.opacity(0.12))
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.08 : 0.95)
                .animation(Animation.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: isAnimating)
            
            // Plant Pot & Leaves
            VStack(spacing: 2) {
                // Leaves
                HStack(spacing: -2) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 22))
                        .foregroundColor(SproutTheme.sproutGreen)
                        .rotationEffect(.degrees(isAnimating ? -28 : -20))
                        .offset(x: 2, y: 3)
                    
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 26))
                        .foregroundColor(SproutTheme.sproutGreenDark)
                        .rotationEffect(.degrees(isAnimating ? 15 : 22))
                        .offset(x: -2)
                }
                .animation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                
                // Stem
                Capsule()
                    .fill(SproutTheme.sproutGreenDark)
                    .frame(width: 4, height: 14)
                
                // Pot
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(SproutTheme.surfaceContainerHigh)
                        .frame(width: 36, height: 24)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 11))
                        .foregroundColor(SproutTheme.brand)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
