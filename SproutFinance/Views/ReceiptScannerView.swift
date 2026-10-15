//
//  ReceiptScannerView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI
import PhotosUI

public struct ReceiptScannerView: View {
    @Environment(FinanceStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var flashOn: Bool = false
    @State private var laserOffsetRatio: CGFloat = 0.1
    @State private var laserMovingDown: Bool = true
    
    // Scanned Receipt Data
    @State private var merchantName: String = "Whole Foods Market"
    @State private var amountValue: Double = 42.80
    @State private var category: ExpenseCategory = .groceries
    @State private var dateString: String = "Today, 11:24 AM"
    @State private var paymentMethod: String = "Apple Pay (•• 4821)"
    @State private var confidence: Int = 99
    
    // Status states
    @State private var isLogging: Bool = false
    @State private var isLogged: Bool = false
    @State private var showManualEditSheet: Bool = false
    
    // Custom receipt image picker
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var scannedReceiptImage: UIImage? = nil
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Viewfinder Area
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    
                    ZStack {
                        // Background Receipt Image
                        if let img = scannedReceiptImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: w, height: h)
                                .clipped()
                                .brightness(-0.1)
                        } else {
                            Image("SampleReceipt")
                                .resizable()
                                .scaledToFill()
                                .frame(width: w, height: h)
                                .clipped()
                                .brightness(flashOn ? 0.1 : -0.15)
                                .contrast(1.05)
                        }
                        
                        // Dark Vignette Gradient
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.55),
                                Color.clear,
                                Color.black.opacity(0.7)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Top Floating In-Viewfinder Bar
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Circle()
                                        .fill(Color.white.opacity(0.85))
                                        .frame(width: 44, height: 44)
                                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
                                        .overlay(
                                            Image(systemName: "xmark")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(SproutTheme.textPrimary)
                                        )
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 10) {
                                    // Photos Picker
                                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                        Circle()
                                            .fill(Color.white.opacity(0.85))
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Image(systemName: "photo.on.rectangle")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(SproutTheme.textPrimary)
                                            )
                                    }
                                    
                                    // Flash Button
                                    Button {
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        flashOn.toggle()
                                    } label: {
                                        Circle()
                                            .fill(flashOn ? SproutTheme.brand : Color.white.opacity(0.85))
                                            .frame(width: 44, height: 44)
                                            .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
                                            .overlay(
                                                Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(flashOn ? .white : SproutTheme.textPrimary)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            
                            Spacer()
                        }
                        
                        // Active Optical Target Reticle Frame
                        ZStack {
                            let frameW: CGFloat = w * 0.78
                            let frameH: CGFloat = h * 0.68
                            
                            // Glowing border
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(SproutTheme.brand.opacity(0.2), lineWidth: 1)
                                .frame(width: frameW, height: frameH)
                                .shadow(color: SproutTheme.brand.opacity(0.3), radius: 12)
                            
                            // 4 Corner Brackets
                            TargetBracketShape()
                                .stroke(SproutTheme.brand, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                .frame(width: frameW, height: frameH)
                            
                            // Center Crosshairs
                            ZStack {
                                Rectangle()
                                    .fill(SproutTheme.surfaceContainerHigh.opacity(0.4))
                                    .frame(width: 24, height: 1)
                                Rectangle()
                                    .fill(SproutTheme.surfaceContainerHigh.opacity(0.4))
                                    .frame(width: 1, height: 24)
                            }
                            
                            // Dynamic Laser Beam
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, SproutTheme.brand, .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: frameW - 24, height: 2.5)
                                .shadow(color: SproutTheme.brand, radius: 8, x: 0, y: 0)
                                .position(x: frameW / 2, y: frameH * laserOffsetRatio)
                            
                            // Active Detected Bounding Boxes
                            // Bounding Box 1: Merchant
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(SproutTheme.brand)
                                    .frame(width: 6, height: 6)
                                Text(merchantName.uppercased())
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(SproutTheme.brand.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .position(x: frameW * 0.35, y: frameH * 0.28)
                            
                            // Bounding Box 2: Total
                            HStack(spacing: 4) {
                                Text("$\(String(format: "%.2f", amountValue))")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(SproutTheme.brand.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .position(x: frameW * 0.72, y: frameH * 0.70)
                            
                            // Live OCR Status Chip
                            VStack {
                                Spacer()
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(SproutTheme.brand)
                                        .frame(width: 7, height: 7)
                                    Text("VISION NEURAL OCR ACTIVE")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(Color.white)
                                        .tracking(1)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color(hex: "0F172A").opacity(0.85))
                                .clipShape(Capsule())
                                .padding(.bottom, 12)
                            }
                            .frame(width: frameW, height: frameH)
                        }
                    }
                }
                .aspectRatio(4/4.8, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                
                // Floating Bottom Sheet Container
                VStack(spacing: 16) {
                    // Drag Handle
                    Capsule()
                        .fill(SproutTheme.borderIce)
                        .frame(width: 40, height: 4)
                        .padding(.top, 10)
                    
                    // Auto-Detected Badge
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(SproutTheme.brand)
                            Text("Auto-Detected • \(confidence)% Confidence")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(SproutTheme.brand)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(SproutTheme.surfaceContainerHigh)
                        .clipShape(Capsule())
                        
                        Spacer()
                    }
                    
                    // Detected Data Presentation Row
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Merchant")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(SproutTheme.textSecondary)
                            Text(merchantName)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(SproutTheme.textPrimary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Total Amount")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(SproutTheme.textSecondary)
                            Text("$\(String(format: "%.2f", amountValue))")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(SproutTheme.textPrimary)
                        }
                    }
                    
                    // Categorized Insight Tile
                    HStack {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(SproutTheme.surfaceContainerHigh)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: category.icon)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(SproutTheme.brand)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Categorized As")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(SproutTheme.textSecondary)
                                Text("\(category.rawValue) & Dining")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(SproutTheme.textPrimary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                            Text("Verified")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(SproutTheme.brand)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(SproutTheme.surfaceContainerHigh)
                        .clipShape(Capsule())
                    }
                    .padding(14)
                    .background(SproutTheme.surfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    
                    // Metadata Bento Row
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Detected Date")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(SproutTheme.textSecondary)
                            Text(dateString)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(SproutTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(SproutTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Payment Method")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(SproutTheme.textSecondary)
                            Text(paymentMethod)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(SproutTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(SproutTheme.surfaceSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    // Actions: Log Transaction CTA
                    VStack(spacing: 12) {
                        Button {
                            performLogTransaction()
                        } label: {
                            HStack(spacing: 8) {
                                if isLogged {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Receipt Logged!")
                                        .font(.system(size: 16, weight: .bold))
                                } else if isLogging {
                                    ProgressView()
                                        .tint(.white)
                                    Text("Saving Entry...")
                                        .font(.system(size: 16, weight: .semibold))
                                } else {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 18, weight: .semibold))
                                    Text("Log Transaction")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(isLogged ? SproutTheme.sproutGreen : SproutTheme.brand)
                            .clipShape(Capsule())
                            .shadow(color: isLogged ? SproutTheme.sproutGreen.opacity(0.3) : SproutTheme.glowBrand, radius: 14, x: 0, y: 6)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(isLogging || isLogged)
                        
                        // Retake & Edit Manually
                        HStack(spacing: 20) {
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                cycleDemoReceipt()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 13, weight: .semibold))
                                    Text("Cycle Sample")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundColor(SproutTheme.textSecondary)
                            }
                            
                            Circle()
                                .fill(SproutTheme.borderIce)
                                .frame(width: 4, height: 4)
                            
                            Button {
                                showManualEditSheet = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 13, weight: .semibold))
                                    Text("Edit Manually")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundColor(SproutTheme.textSecondary)
                            }
                        }
                        .padding(.top, 2)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: -6)
            }
        }
        .onAppear {
            startLaserAnimation()
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    await MainActor.run {
                        self.scannedReceiptImage = uiImg
                        self.merchantName = "Target Store #2814"
                        self.amountValue = 36.50
                        self.category = .shopping
                        self.confidence = 98
                    }
                }
            }
        }
        .sheet(isPresented: $showManualEditSheet) {
            EditTransactionSheet(
                merchant: $merchantName,
                amount: $amountValue,
                category: $category,
                paymentMethod: $paymentMethod
            )
        }
    }
    
    private func startLaserAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            if laserMovingDown {
                laserOffsetRatio += 0.015
                if laserOffsetRatio >= 0.88 {
                    laserMovingDown = false
                }
            } else {
                laserOffsetRatio -= 0.015
                if laserOffsetRatio <= 0.12 {
                    laserMovingDown = true
                }
            }
        }
    }
    
    private func cycleDemoReceipt() {
        if merchantName == "Whole Foods Market" {
            merchantName = "Blue Bottle Coffee"
            amountValue = 6.85
            category = .dining
            paymentMethod = "Apple Pay (•• 4821)"
        } else if merchantName == "Blue Bottle Coffee" {
            merchantName = "Trader Joe's"
            amountValue = 54.10
            category = .groceries
            paymentMethod = "Card ••4829"
        } else {
            merchantName = "Whole Foods Market"
            amountValue = 42.80
            category = .groceries
            paymentMethod = "Apple Pay (•• 4821)"
        }
    }
    
    private func performLogTransaction() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        isLogging = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            isLogging = false
            isLogged = true
            
            let notificationImpact = UINotificationFeedbackGenerator()
            notificationImpact.notificationOccurred(.success)
            
            // Add into real store
            store.addTransaction(
                merchant: merchantName,
                amount: amountValue,
                category: category,
                paymentMethod: paymentMethod,
                note: "Auto-captured with Vision Neural OCR",
                isScanned: true
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                dismiss()
            }
        }
    }
}

// MARK: - 4 Corner Brackets Shape
struct TargetBracketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let arm: CGFloat = 36
        let r: CGFloat = 20
        
        // Top Left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + arm))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        path.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + arm, y: rect.minY))
        
        // Top Right
        path.move(to: CGPoint(x: rect.maxX - arm, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r), radius: r, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + arm))
        
        // Bottom Right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - arm))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        path.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - arm, y: rect.maxY))
        
        // Bottom Left
        path.move(to: CGPoint(x: rect.minX + arm, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - arm))
        
        return path
    }
}
