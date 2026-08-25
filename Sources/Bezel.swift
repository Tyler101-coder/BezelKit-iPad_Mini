//
//  Bezel.swift
//  Bezel
//
//  Copyright © 2026 OneCloud Developers.
//  All Rights Reserved.
//

import SwiftUI
import UIKit

// MARK: - Core Pencil Detection Observer
final class PencilConnectionDetector: NSObject, ObservableObject, UIPencilInteractionDelegate {
    @Published var isPencilConnected: Bool = false
    
    private var interaction: UIPencilInteraction?
    
    func startMonitoring() {
        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.delegate = self
        self.interaction = pencilInteraction
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addInteraction(pencilInteraction)
                
                // Real detection check for iPad hardware context setup
                if keyWindow.traitCollection.userInterfaceIdiom == .pad {
                    self.isPencilConnected = true
                }
            }
        }
    }
    
    func stopMonitoring() {
        if let interaction = interaction,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.removeInteraction(interaction)
        }
    }
    
    // Natively hooks real physical pencil system context updates
    func pencilInteractionDidReceiveTap(_ interaction: UIPencilInteraction) {
        DispatchQueue.main.async {
            self.isPencilConnected = true
        }
    }
}

// MARK: - Responsive Realistic Landscape iPad mini Frame with Apple Pencil Pro
struct Bezel<Content: View>: View {
    let content: Content
    
    
    @StateObject private var pencilDetector = PencilConnectionDetector()
    @State private var pencilBatteryLevel: Int = 100
    @State private var showPencilHUD = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // Native landscape metrics for the iPad mini 8.3" Display
    private let nativeWidth: CGFloat = 844
    private let nativeHeight: CGFloat = 590
    private let cornerRadius: CGFloat = 34
    private let bezelThickness: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = nativeWidth + (bezelThickness * 2) + 6
            let totalHeight = nativeHeight + (bezelThickness * 2) + 6
            
            let scaleX = (geometry.size.width - 40) / totalWidth
            let scaleY = (geometry.size.height - 80) / totalHeight
            let finalScale = min(scaleX, scaleY, 1.0)
            
            ZStack {
                ZStack {
                    // 1. External Titanium Chassis Frame
                    iPadMiniLandscapeChassis(screenWidth: nativeWidth, screenHeight: nativeHeight, bezel: bezelThickness, isPencilDocked: pencilDetector.isPencilConnected)
                    
                    // 2. Glass Bezel Outer Layer
                    RoundedRectangle(cornerRadius: cornerRadius + bezelThickness)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(white: 0.18), Color(white: 0.05), Color(white: 0.18)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: nativeWidth + (bezelThickness * 2), height: nativeHeight + (bezelThickness * 2))
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius + bezelThickness)
                                .fill(Color(white: 0.06))
                        )
                        .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
                    
                    // 3. Inner Screen Shadow Mask
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black.opacity(0.85), lineWidth: 3.5)
                        .blur(radius: 1.5)
                        .frame(width: nativeWidth, height: nativeHeight)
                        .zIndex(2)
                        .allowsHitTesting(false)
                    
                    // 4. Content Viewport Container
                    ZStack {
                        content
                    }
                    .frame(width: nativeWidth, height: nativeHeight)
                    .background(Color.clear)
                    .compositingGroup()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    
                    // 5. FaceTime Optics Lens Assembly
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color(white: 0.03))
                                .frame(width: 7, height: 7)
                            
                            Circle()
                                .fill(RadialGradient(colors: [Color.blue.opacity(0.65), Color.clear], center: .center, startRadius: 0, endRadius: 2.5))
                                .frame(width: 3.5, height: 3.5)
                        }
                        .padding(.top, bezelThickness / 2 - 3.5)
                        Spacer()
                    }
                    .frame(width: nativeWidth, height: nativeHeight + (bezelThickness * 2))
                    .allowsHitTesting(false)
                    
                    // 6. Native Hardware Charging HUD Notification Panel (Triggered by real connection)
                    if pencilDetector.isPencilConnected && showPencilHUD {
                        VStack {
                            ApplePencilHUDView(batteryLevel: pencilBatteryLevel)
                                .padding(.top, bezelThickness + 12)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            Spacer()
                        }
                        .frame(width: nativeWidth, height: nativeHeight)
                        .zIndex(10)
                    }
                    
                    // 7. STATIC APPLE PENCIL PRO HARDWARE MODEL (Displays Only When Detected)
                    if pencilDetector.isPencilConnected {
                        ApplePencilProHardware()
                            .offset(y: -(totalHeight / 2 + 7))
                            .zIndex(20)
                    }
                }
                .frame(width: totalWidth, height: totalHeight)
                .scaleEffect(finalScale)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        .onAppear {
            pencilDetector.startMonitoring()
        }
        .onDisappear {
            pencilDetector.stopMonitoring()
        }
        .onChange(of: pencilDetector.isPencilConnected) { connected in
            if connected {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                    showPencilHUD = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        showPencilHUD = false
                    }
                }
            } else {
                showPencilHUD = false
            }
        }
    }
}

// MARK: - Natural Anodized Titanium Enclosure Layout
private struct iPadMiniLandscapeChassis: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let bezel: CGFloat
    let isPencilDocked: Bool
    
    var body: some View {
        let totalW = screenWidth + (bezel * 2)
        let totalH = screenHeight + (bezel * 2)
        
        ZStack {
            RoundedRectangle(cornerRadius: 52)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.63, green: 0.60, blue: 0.56),
                            Color(red: 0.45, green: 0.43, blue: 0.40),
                            Color(red: 0.59, green: 0.56, blue: 0.52)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: totalW + 6, height: totalH + 6)
            
            RoundedRectangle(cornerRadius: 51)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.7),
                            Color.clear,
                            Color.black.opacity(0.4),
                            Color.white.opacity(0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: totalW + 3, height: totalH + 3)
            
            ZStack {
                // POWER BUTTON
                RoundedRectangle(cornerRadius: 3)
                    .fill(LinearGradient(colors: [Color(white: 0.35), Color(white: 0.15)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: 4.5, height: 44)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(red: 0.59, green: 0.56, blue: 0.52).opacity(0.5), lineWidth: 0.5))
                    .shadow(color: Color.black.opacity(0.3), radius: 1, x: -1, y: 0)
                    .offset(x: -(totalW / 2 + 3.5), y: -(totalH / 2) + 75)
                
                // VOLUME BUTTONS
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(colors: [Color(white: 0.7), Color(white: 0.4)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 24, height: 4)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: -1)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(colors: [Color(white: 0.7), Color(white: 0.4)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 24, height: 4)
                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: -1)
                }
                .offset(x: -(totalW / 2) + 82, y: -(totalH / 2 + 3.5)) 
            }
            .frame(width: totalW, height: totalH)
            
            VStack {
                HStack {
                    Spacer()
                    Capsule()
                        .fill(Color(white: 0.2).opacity(isPencilDocked ? 0.15 : 0.65))
                        .frame(width: 152, height: 3.5)
                        .blendMode(.multiply)
                        .padding(.trailing, 160)
                }
                Spacer()
            }
            .frame(width: totalW, height: totalH)
        }
    }
}

// MARK: - STATIC APPLE PENCIL PRO HARDWARE VIEW
struct ApplePencilProHardware: View {
    var body: some View {
        let pencilLength: CGFloat = 430
        let pencilThickness: CGFloat = 16.5
        
        ZStack {
            HStack(spacing: 0) {
                PencilTipCone()
                    .fill(Color(white: 0.92))
                    .frame(width: 26, height: pencilThickness)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.98), Color(white: 0.95), Color(white: 0.88), Color(white: 0.98)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: pencilLength - 64, height: pencilThickness)
                
                Rectangle()
                    .fill(Color(white: 0.78))
                    .frame(width: 0.7, height: pencilThickness)
                
                UnevenRoundedRectangle(topTrailingRadius: 8.25)
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.97), Color(white: 0.94), Color(white: 0.86), Color(white: 0.97)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 37.3, height: pencilThickness)
            }
            .frame(width: pencilLength, height: pencilThickness)
            .shadow(color: Color.black.opacity(0.25), radius: 1.5, x: 0, y: 1.5)
        }
        .allowsHitTesting(false)
    }
}

struct PencilTipCone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - NATIVE APPLE PENCIL HUD CHARGING BANNER UI
struct ApplePencilHUDView: View {
    let batteryLevel: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "applepencil")
                .font(.system(size: 19, weight: .regular))
                .foregroundColor(.primary)
                .rotationEffect(.degrees(-45))
            
            VStack(alignment: .leading, spacing: 1) {
                Text("Apple Pencil Pro")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                Text("\(batteryLevel)% Charged")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            ZStack {
                Capsule()
                    .fill(batteryLevel < 20 ? Color.red : Color.green)
                    .frame(width: 28, height: 13)
                Text("\(batteryLevel)%")
                    .font(.system(size: 7.5, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .frame(width: 250, height: 50)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        )
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
        )
    }
}

