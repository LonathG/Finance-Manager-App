//
//  LoginView.swift
//  SproutFinance
//
//  Created by Rusheni Botheju on 2026-10-15.
//

import SwiftUI

public struct LoginView: View {
    @Environment(FinanceStore.self) private var store
    var onLoginSuccess: () -> Void
    var onBack: () -> Void
    
    @State private var email: String = "alex.morgan@example.com"
    @State private var password: String = "••••••••••••"
    @State private var isPasswordVisible: Bool = false
    @State private var rememberMe: Bool = true
    @State private var isAuthenticatingFaceID: Bool = false
    @State private var showFaceIDSuccess: Bool = false
    @State private var isSigningIn: Bool = false
    @State private var showForgotPasswordAlert: Bool = false
    @State private var showSignUpSheet: Bool = false
    
    public init(onLoginSuccess: @escaping () -> Void, onBack: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
        self.onBack = onBack
    }
    
    public var body: some View {
        ZStack {
            SproutTheme.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Back Navigation Button
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        onBack()
                    } label: {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 44, height: 44)
                            .shadow(color: SproutTheme.cardShadow, radius: 8, x: 0, y: 2)
                            .overlay(
                                Circle()
                                    .stroke(SproutTheme.borderIce.opacity(0.8), lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(SproutTheme.textPrimary)
                            )
                    }
                    .padding(.top, 12)
                    
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        // Secure Access Badge
                        HStack(spacing: 6) {
                            Text("Secure Access")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(SproutTheme.brand)
                            Text("🔒")
                                .font(.system(size: 11))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(SproutTheme.surfaceContainerHigh)
                        .clipShape(Capsule())
                        
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(SproutTheme.textPrimary)
                            .tracking(-0.5)
                        
                        Text("Enter your credentials to access your Sprout envelopes.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(SproutTheme.textSecondary)
                    }
                    .padding(.top, 4)
                    
                    // Credentials Form
                    VStack(spacing: 16) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Sprout ID / Email")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(SproutTheme.textSecondary)
                                .padding(.leading, 8)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(SproutTheme.textSecondary)
                                
                                TextField("name@example.com", text: $email)
                                    .font(.system(size: 15))
                                    .foregroundColor(SproutTheme.textPrimary)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(SproutTheme.borderIce, lineWidth: 1)
                            )
                            .shadow(color: SproutTheme.cardShadow, radius: 6, x: 0, y: 2)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(SproutTheme.textSecondary)
                                .padding(.leading, 8)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(SproutTheme.textSecondary)
                                
                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .font(.system(size: 15))
                                        .foregroundColor(SproutTheme.textPrimary)
                                } else {
                                    SecureField("Password", text: $password)
                                        .font(.system(size: 15))
                                        .foregroundColor(SproutTheme.textPrimary)
                                }
                                
                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(SproutTheme.textSecondary)
                                }
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 54)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(SproutTheme.borderIce, lineWidth: 1)
                            )
                            .shadow(color: SproutTheme.cardShadow, radius: 6, x: 0, y: 2)
                        }
                        
                        // Remember Me & Forgot Password
                        HStack {
                            Button {
                                rememberMe.toggle()
                            } label: {
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(rememberMe ? SproutTheme.brand : Color.white)
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                Circle()
                                                    .stroke(rememberMe ? SproutTheme.brand : SproutTheme.borderIce, lineWidth: 1.5)
                                            )
                                        
                                        if rememberMe {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Text("Remember me")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(SproutTheme.textSecondary)
                                }
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                            
                            Button {
                                showForgotPasswordAlert = true
                            } label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(SproutTheme.brand)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // Primary Sign In Button
                        Button {
                            performSignIn()
                        } label: {
                            HStack(spacing: 8) {
                                if isSigningIn {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 16, weight: .semibold))
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(SproutTheme.brand)
                            .clipShape(Capsule())
                            .shadow(color: SproutTheme.glowBrand, radius: 14, x: 0, y: 6)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(isSigningIn)
                        
                        // Face ID Button
                        Button {
                            performFaceID()
                        } label: {
                            HStack(spacing: 8) {
                                if showFaceIDSuccess {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(SproutTheme.sproutGreen)
                                    Text("Verified with Face ID")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(SproutTheme.sproutGreen)
                                } else if isAuthenticatingFaceID {
                                    ProgressView()
                                        .tint(SproutTheme.brand)
                                    Text("Scanning Biometrics...")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(SproutTheme.brand)
                                } else {
                                    Image(systemName: "faceid")
                                        .font(.system(size: 18))
                                        .foregroundColor(SproutTheme.brand)
                                    Text("Sign in with Face ID")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(SproutTheme.brand)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(SproutTheme.borderIce, lineWidth: 1)
                            )
                            .shadow(color: SproutTheme.cardShadow, radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(isAuthenticatingFaceID)
                    }
                    .padding(.top, 6)
                    
                    // Hairline Divider
                    HStack {
                        Rectangle()
                            .fill(SproutTheme.borderIce)
                            .frame(height: 1)
                        
                        Text("OR CONTINUE WITH")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(SproutTheme.textSecondary)
                            .padding(.horizontal, 12)
                        
                        Rectangle()
                            .fill(SproutTheme.borderIce)
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)
                    
                    // Social Sign In Buttons
                    HStack(spacing: 12) {
                        // Apple
                        Button {
                            performSignIn()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 16))
                                Text("Apple")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(SproutTheme.textPrimary)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        // Google
                        Button {
                            performSignIn()
                        } label: {
                            HStack(spacing: 8) {
                                Text("G")
                                    .font(.system(size: 16, weight: .heavy))
                                    .foregroundColor(SproutTheme.brand)
                                Text("Google")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(SproutTheme.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(SproutTheme.borderIce, lineWidth: 1)
                            )
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    
                    // Footer
                    HStack {
                        Spacer()
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(SproutTheme.textSecondary)
                        
                        Button {
                            showSignUpSheet = true
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(SproutTheme.brand)
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 20)
            }
        }
        .alert("Reset Password", isPresented: $showForgotPasswordAlert) {
            Button("Send Reset Link", role: .none) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("We'll send password recovery instructions to \(email).")
        }
        .sheet(isPresented: $showSignUpSheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Create Sprout Account")
                        .font(.title2.bold())
                    Text("Join thousands cultivating healthy financial habits.")
                        .font(.subheadline)
                        .foregroundColor(SproutTheme.textSecondary)
                    
                    Button("Create Instant Demo Account") {
                        showSignUpSheet = false
                        performSignIn()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(SproutTheme.brand)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showSignUpSheet = false }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func performSignIn() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        isSigningIn = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isSigningIn = false
            store.isAuthenticated = true
            store.hasCompletedOnboarding = true
            onLoginSuccess()
        }
    }
    
    private func performFaceID() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        isAuthenticatingFaceID = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            isAuthenticatingFaceID = false
            showFaceIDSuccess = true
            let successImpact = UINotificationFeedbackGenerator()
            successImpact.notificationOccurred(.success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                store.isAuthenticated = true
                store.hasCompletedOnboarding = true
                onLoginSuccess()
            }
        }
    }
}
