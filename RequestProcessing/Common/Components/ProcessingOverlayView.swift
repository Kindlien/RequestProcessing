//
//  ProcessingOverlayView.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct ProcessingOverlayView: View {
    @State private var progress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)

            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 200 + CGFloat(i * 100), height: 200 + CGFloat(i * 100))
                    .scaleEffect(pulseScale)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.3),
                        value: pulseScale
                    )
            }

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 80, height: 80)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [AppTheme.lightTeal, Color.white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotation))

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .scaleEffect(pulseScale)
                }

                LoadingDotsView()
            }
            .scaleEffect(pulseScale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.2
            }

            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                progress = 1.0
            }

            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
