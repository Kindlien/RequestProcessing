//
//  SplashScreenView.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showLoading: Bool = false
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppTheme.primaryTeal,
                    AppTheme.primaryTeal.opacity(0.8),
                    AppTheme.lightTeal.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

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

            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale * 1.1)
                        .blur(radius: 10)

                    Circle()
                        .fill(.white)
                        .frame(width: 180, height: 180)
                        .overlay(
                            Image("ic_Via")
                                .resizable()
                                .frame(width: 130, height: 43)
                                .rotationEffect(.degrees(rotation))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .padding(.top, 60)

                LoadingDotsView()
                    .opacity(showLoading ? 1 : 0)
                    .offset(y: showLoading ? 0 : 10)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                rotation = 360
            }

            withAnimation(.easeInOut(duration: 0.4).delay(0.6)) {
                showLoading = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pulseScale = 1.2
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    opacity = 0
                    scale = 1.2
                    showLoading = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onComplete()
                }
            }
        }
    }
}
