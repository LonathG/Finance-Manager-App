//
//  SparklineChartView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct SparklineChartView: View {
    public var isThisWeek: Bool
    @State private var hoveredDay: Int? = 4 // Default to Friday (4)
    
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    public init(isThisWeek: Bool) {
        self.isThisWeek = isThisWeek
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                
                ZStack {
                    // Area Gradient
                    ChartAreaShape(isThisWeek: isThisWeek)
                        .fill(
                            LinearGradient(
                                colors: [
                                    SproutTheme.brand.opacity(0.24),
                                    SproutTheme.brand.opacity(0.04),
                                    Color.white.opacity(0.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Chart Stroke Curve
                    ChartCurveShape(isThisWeek: isThisWeek)
                        .stroke(
                            SproutTheme.brand,
                            style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                        )
                    
                    // Milestone Dots
                    if isThisWeek {
                        // Mon
                        DotView(point: CGPoint(x: (10.0 / 340.0) * w, y: (105.0 / 140.0) * h), hasGlow: false)
                        // Wed
                        DotView(point: CGPoint(x: (115.0 / 340.0) * w, y: (85.0 / 140.0) * h), hasGlow: false)
                        // Fri (Spike)
                        DotView(point: CGPoint(x: (220.0 / 340.0) * w, y: (38.0 / 140.0) * h), hasGlow: true)
                        // Sun (Peak)
                        DotView(point: CGPoint(x: (330.0 / 340.0) * w, y: (22.0 / 140.0) * h), hasGlow: true)
                    } else {
                        // Last week points
                        DotView(point: CGPoint(x: (10.0 / 340.0) * w, y: (65.0 / 140.0) * h), hasGlow: false)
                        DotView(point: CGPoint(x: (125.0 / 340.0) * w, y: (70.0 / 140.0) * h), hasGlow: false)
                        DotView(point: CGPoint(x: (235.0 / 340.0) * w, y: (90.0 / 140.0) * h), hasGlow: true)
                        DotView(point: CGPoint(x: (330.0 / 340.0) * w, y: (55.0 / 140.0) * h), hasGlow: true)
                    }
                }
            }
            .frame(height: 130)
            
            // Day Labels along the base
            HStack {
                ForEach(0..<days.count, id: \.self) { idx in
                    let isSpecial = (isThisWeek && (idx == 4 || idx == 6)) // Fri & Sun bold
                    Text(days[idx])
                        .font(.system(size: 13, weight: isSpecial ? .bold : .medium))
                        .foregroundColor(isSpecial ? SproutTheme.brand : SproutTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Curve Shape
struct ChartCurveShape: Shape {
    var isThisWeek: Bool
    
    var animatableData: Double {
        get { isThisWeek ? 1.0 : 0.0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let sx = rect.width / 340.0
        let sy = rect.height / 140.0
        
        if isThisWeek {
            path.move(to: CGPoint(x: 10 * sx, y: 105 * sy))
            path.addCurve(
                to: CGPoint(x: 115 * sx, y: 85 * sy),
                control1: CGPoint(x: 50 * sx, y: 110 * sy),
                control2: CGPoint(x: 75 * sx, y: 70 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 220 * sx, y: 38 * sy),
                control1: CGPoint(x: 150 * sx, y: 98 * sy),
                control2: CGPoint(x: 180 * sx, y: 30 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 330 * sx, y: 22 * sy),
                control1: CGPoint(x: 255 * sx, y: 46 * sy),
                control2: CGPoint(x: 280 * sx, y: 75 * sy)
            )
        } else {
            path.move(to: CGPoint(x: 10 * sx, y: 65 * sy))
            path.addCurve(
                to: CGPoint(x: 125 * sx, y: 70 * sy),
                control1: CGPoint(x: 55 * sx, y: 40 * sy),
                control2: CGPoint(x: 85 * sx, y: 95 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 235 * sx, y: 90 * sy),
                control1: CGPoint(x: 160 * sx, y: 50 * sy),
                control2: CGPoint(x: 195 * sx, y: 110 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 330 * sx, y: 55 * sy),
                control1: CGPoint(x: 270 * sx, y: 70 * sy),
                control2: CGPoint(x: 295 * sx, y: 45 * sy)
            )
        }
        return path
    }
}

// MARK: - Area Fill Shape
struct ChartAreaShape: Shape {
    var isThisWeek: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let sx = rect.width / 340.0
        let sy = rect.height / 140.0
        
        if isThisWeek {
            path.move(to: CGPoint(x: 10 * sx, y: 105 * sy))
            path.addCurve(
                to: CGPoint(x: 115 * sx, y: 85 * sy),
                control1: CGPoint(x: 50 * sx, y: 110 * sy),
                control2: CGPoint(x: 75 * sx, y: 70 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 220 * sx, y: 38 * sy),
                control1: CGPoint(x: 150 * sx, y: 98 * sy),
                control2: CGPoint(x: 180 * sx, y: 30 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 330 * sx, y: 22 * sy),
                control1: CGPoint(x: 255 * sx, y: 46 * sy),
                control2: CGPoint(x: 280 * sx, y: 75 * sy)
            )
            path.addLine(to: CGPoint(x: 330 * sx, y: rect.height))
            path.addLine(to: CGPoint(x: 10 * sx, y: rect.height))
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: 10 * sx, y: 65 * sy))
            path.addCurve(
                to: CGPoint(x: 125 * sx, y: 70 * sy),
                control1: CGPoint(x: 55 * sx, y: 40 * sy),
                control2: CGPoint(x: 85 * sx, y: 95 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 235 * sx, y: 90 * sy),
                control1: CGPoint(x: 160 * sx, y: 50 * sy),
                control2: CGPoint(x: 195 * sx, y: 110 * sy)
            )
            path.addCurve(
                to: CGPoint(x: 330 * sx, y: 55 * sy),
                control1: CGPoint(x: 270 * sx, y: 70 * sy),
                control2: CGPoint(x: 295 * sx, y: 45 * sy)
            )
            path.addLine(to: CGPoint(x: 330 * sx, y: rect.height))
            path.addLine(to: CGPoint(x: 10 * sx, y: rect.height))
            path.closeSubpath()
        }
        return path
    }
}

// MARK: - Dot View
struct DotView: View {
    let point: CGPoint
    let hasGlow: Bool
    
    var body: some View {
        ZStack {
            if hasGlow {
                Circle()
                    .fill(SproutTheme.brand.opacity(0.35))
                    .frame(width: 16, height: 16)
                    .blur(radius: 4)
            }
            
            Circle()
                .fill(hasGlow ? SproutTheme.brand : Color.white)
                .frame(width: 9, height: 9)
                .overlay(
                    Circle()
                        .stroke(SproutTheme.brand, lineWidth: 2.5)
                )
            
            if hasGlow {
                Circle()
                    .fill(Color.white)
                    .frame(width: 4, height: 4)
            }
        }
        .position(point)
    }
}
