//
//  PencilConnectionDetector.swift
//  BezelKit
//
//  Copyright © 2026 OneCloud Developers.
//  All Rights Reserved.
//

import SwiftUI
import UIKit

@MainActor
public final class PencilConnectionDetector: NSObject, ObservableObject, UIPencilInteractionDelegate {

    @Published public var isPencilConnected: Bool = false

    private var interaction: UIPencilInteraction?

    public override init() {
        super.init()
    }

    public func startMonitoring() {
        let pencilInteraction = UIPencilInteraction()
        pencilInteraction.delegate = self
        interaction = pencilInteraction

        DispatchQueue.main.async {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
            else { return }

            keyWindow.addInteraction(pencilInteraction)

            if keyWindow.traitCollection.userInterfaceIdiom == .pad {
                self.isPencilConnected = true
            }
        }
    }

    public func stopMonitoring() {
        guard
            let interaction,
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        keyWindow.removeInteraction(interaction)
    }

    public func pencilInteractionDidReceiveTap(_ interaction: UIPencilInteraction) {
        DispatchQueue.main.async {
            self.isPencilConnected = true
        }
    }
}

public struct ApplePencilProHardware: View {

    public init() {}

    public var body: some View {

        let pencilLength: CGFloat = 430
        let pencilThickness: CGFloat = 16.5

        HStack(spacing: 0) {

            PencilTipCone()
                .fill(Color(white: 0.92))
                .frame(width: 26, height: pencilThickness)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.98),
                            Color(white: 0.95),
                            Color(white: 0.88),
                            Color(white: 0.98)
                        ],
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
                        colors: [
                            Color(white: 0.97),
                            Color(white: 0.94),
                            Color(white: 0.86),
                            Color(white: 0.97)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 37.3, height: pencilThickness)
        }
        .frame(width: pencilLength, height: pencilThickness)
        .shadow(color: .black.opacity(0.25), radius: 1.5, x: 0, y: 1.5)
        .allowsHitTesting(false)
    }
}

public struct ApplePencilHUDView: View {

    public let batteryLevel: Int

    public init(batteryLevel: Int) {
        self.batteryLevel = batteryLevel
    }

    public var body: some View {

        HStack(spacing: 16) {

            Image(systemName: "applepencil")
                .font(.system(size: 19))
                .rotationEffect(.degrees(-45))

            VStack(alignment: .leading, spacing: 1) {

                Text("Apple Pencil Pro")
                    .font(.system(size: 13, weight: .semibold))

                Text("\(batteryLevel)% Charged")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ZStack {

                Capsule()
                    .fill(batteryLevel < 20 ? .red : .green)
                    .frame(width: 28, height: 13)

                Text("\(batteryLevel)%")
                    .font(.system(size: 7.5, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .frame(width: 250, height: 50)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
        )
    }
}

public struct PencilTipCone: Shape {

    public init() {}

    public func path(in rect: CGRect) -> Path {

        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}


public struct Bezel<Content: View>: View {

    private let content: Content

    @StateObject private var pencilDetector = PencilConnectionDetector()
    @State private var pencilBatteryLevel = 100
    @State private var showPencilHUD = false

    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    public var body: some View {

        ZStack {

            content

            if pencilDetector.isPencilConnected &&
                showPencilHUD {

                ApplePencilHUDView(
                    batteryLevel: pencilBatteryLevel
                )
            }
        }
        .onAppear {
            pencilDetector.startMonitoring()
        }
        .onDisappear {
            pencilDetector.stopMonitoring()
        }
    }
}
