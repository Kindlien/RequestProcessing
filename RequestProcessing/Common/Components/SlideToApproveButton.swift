//
//  SlideToApproveButton.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 17/12/25.
//

import SwiftUI

struct SlideToApproveButton: View {
    let isLoading: Bool
    let isComplete: Bool
    let isDisabled: Bool
    let result: RequestResult?
    let showShimmer: Bool
    let shimmerOffset: CGFloat
    let onComplete: () -> Void
    let onSlideComplete: () -> Void

    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var hasCompleted = false
    @State private var lastUpdateTime: TimeInterval = 0

    private let thumbSize: CGFloat = 48
    private let trackHeight: CGFloat = 54
    private let padding: CGFloat = 4
    private let borderWidth: CGFloat = 1.5
    private let updateThrottleInterval: TimeInterval = 0.016

    private var isInteractionDisabled: Bool {
        isDisabled || isLoading || hasCompleted || isComplete
    }

    private var wasSuccessful: Bool {
        if case .success(.approve) = result {
            return true
        }
        return false
    }

    private var wasFailed: Bool {
        if case .failure = result {
            return true
        } else if case .success(.reject) = result {
            return true
        }
        return false
    }

    private var fillColor: LinearGradient {
        if wasFailed {
            return LinearGradient(
                colors: [AppTheme.errorRed, AppTheme.errorRed.opacity(0.9)],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [AppTheme.lightTeal, AppTheme.lightTeal.opacity(0.9)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    private var borderColor: Color {
        if wasFailed {
            return AppTheme.errorRed
        } else if wasSuccessful {
            return AppTheme.lightTeal
        } else {
            return AppTheme.lightTeal
        }
    }

    private var buttonText: String {
        if wasFailed {
            return "Failed"
        } else if wasSuccessful {
            return "Approved"
        } else if hasCompleted {
            return "Processing..."
        } else {
            return "Slide to approve"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let maxOffset = geometry.size.width - thumbSize - (padding * 2)
            let fillWidth = offset + thumbSize + padding

            ZStack(alignment: .leading) {

                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.primaryTeal)
                    .frame(height: thumbSize)

                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(fillColor)
                    .frame(width: (hasCompleted && !isLoading) ? geometry.size.width : fillWidth, height: thumbSize)
                    .opacity(showShimmer ? 0 : 1)

                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .frame(height: thumbSize)

                if showShimmer {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: thumbSize)

                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0),
                                        Color.white.opacity(0.7),
                                        Color.white.opacity(0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 120, height: thumbSize)
                            .offset(x: shimmerOffset)
                            .blur(radius: 10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                }

                Text(buttonText)
                    .font(AppTheme.mainButtonFont)
                    .foregroundColor(wasFailed ? AppTheme.errorTextRed : (wasSuccessful ? AppTheme.successTextDarkBlue : AppTheme.backgroundLight))
                    .frame(maxWidth: .infinity)
                    .opacity(isDragging ? 0.6 : 1.0)
                    .opacity(showShimmer ? 0 : 1)

                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.backgroundLight)
                        .frame(width: 56, height: trackHeight)
                        .shadow(color: Color.black.opacity(0.16), radius: 1.5, x: 0, y: 3)
                        .opacity(showShimmer ? 0 : 1)
                        .overlay(
                            ZStack {
                                if wasFailed {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(AppTheme.errorTextRed)
                                } else if wasSuccessful {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(AppTheme.secondaryTeal)
                                } else if isLoading {
                                    ProgressView()
                                        .tint(AppTheme.primaryTeal)
                                } else {
                                    Image(systemName: "chevron.right.2")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(AppTheme.secondaryTeal)
                                        .offset(x: isDragging ? 2 : 0)
                                }
                            }
                        )
                        .scaleEffect(isDragging ? 1.05 : 1.0)
                        .offset(x: offset + padding)
                        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.8), value: offset)
                        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.8), value: isDragging)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    guard !isInteractionDisabled else { return }

                                    let currentTime = CACurrentMediaTime()
                                    guard currentTime - lastUpdateTime >= updateThrottleInterval else { return }
                                    lastUpdateTime = currentTime

                                    if !isDragging {
                                        isDragging = true
                                    }

                                    let newOffset = min(max(0, value.translation.width), maxOffset)
                                    offset = newOffset

                                    if offset >= maxOffset * 0.85 && offset < maxOffset * 0.86 {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                }
                                .onEnded { _ in
                                    guard !isInteractionDisabled else { return }

                                    isDragging = false

                                    if offset >= maxOffset * 0.85 {
                                        offset = maxOffset
                                        hasCompleted = true

                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        onSlideComplete()

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            onComplete()
                                        }
                                    } else {
                                        offset = 0
                                    }
                                }
                        )

                    Spacer()
                }
            }
        }
        .frame(height: trackHeight)
        .allowsHitTesting(!isInteractionDisabled)
        .disabled(isInteractionDisabled)
        .opacity(isInteractionDisabled && !hasCompleted && !showShimmer ? 0.5 : (showShimmer ? 0.7 : 1))
        .onAppear {
            offset = 0
            isDragging = false
            hasCompleted = false
            lastUpdateTime = 0
        }
        .onDisappear {
            offset = 0
            isDragging = false
            hasCompleted = false
            lastUpdateTime = 0
        }
        .onChange(of: isLoading) { loading in
            if !loading && !hasCompleted && offset > 0 {
                DispatchQueue.main.async {
                    offset = 0
                }
            }
        }
    }
}
