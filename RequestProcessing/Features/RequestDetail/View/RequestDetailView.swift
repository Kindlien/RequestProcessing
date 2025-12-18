//
//  RequestDetailView.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct RequestDetailView: View {
    @ObservedObject var viewModel: RequestDetailViewModel
    @ObservedObject var coordinator: MainCoordinator
    let onComplete: (RequestResult) -> Void

    @State private var showContent = false
    @State private var cardScale: CGFloat = 0.9
    @State private var interactionLocked = false
    @State private var allowInteraction = false
    @State private var shimmerOffset: CGFloat = -200

    @State private var sliderKey = UUID()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppTheme.primaryTeal,
                    AppTheme.primaryTeal.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("New Request")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.backgroundLight)
                    .padding(.top, 59)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                Spacer()

                VStack(alignment: .leading, spacing: 15) {
                    Text(viewModel.request.title)
                        .font(AppTheme.cardTitleFont)
                        .foregroundColor(AppTheme.backgroundLight)
                        .padding(.top, AppTheme.paddingSmallMedium)

                    Text(viewModel.request.description)
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.backgroundLight)

                    Spacer()
                }
                .frame(height: 502)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppTheme.paddingMedium)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.backgroundDark)
                        .frame(height: 502)
                )
                .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
                .padding(.horizontal, AppTheme.paddingSmall)
                .scaleEffect(cardScale)
                .opacity(showContent ? 1 : 0)

                Spacer()

                HStack(spacing: 27) {

                    Button {
                        guard !interactionLocked && allowInteraction else { return }

                        interactionLocked = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                        Task {
                            await viewModel.reject()
                            if let result = viewModel.result {
                                onComplete(result)
                                coordinator.goBack()
                            }
                        }
                    } label: {
                        ZStack {
                            Text("Reject")
                                .font(AppTheme.mainButtonFont)
                                .foregroundColor(AppTheme.backgroundLight)
                                .frame(width: 112.12, height: AppTheme.buttonHeight)
                                .background(AppTheme.primaryTeal)
                                .cornerRadius(AppTheme.cornerRadius)
                                .opacity((interactionLocked || !allowInteraction) ? 0.0 : 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                        .stroke(AppTheme.lightTeal, lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.16), radius: 1.5, x: 0, y: 3)

                            if !allowInteraction {
                                ZStack {
                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                        .fill(Color.white.opacity(0.15))

                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0),
                                                    Color.white.opacity(0.6),
                                                    Color.white.opacity(0)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: 100)
                                        .offset(x: shimmerOffset)
                                        .blur(radius: 8)
                                }
                                .frame(width: 112.12, height: AppTheme.buttonHeight)
                                .cornerRadius(AppTheme.cornerRadius)
                            }
                        }
                    }
                    .disabled(interactionLocked || !allowInteraction)
                    .opacity((interactionLocked || !allowInteraction) ? 0.6 : 1)
                    .scaleEffect(interactionLocked ? 0.95 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7),
                               value: interactionLocked)
                    .animation(.easeInOut(duration: 0.3), value: allowInteraction)

                    SlideToApproveButton(
                        isLoading: viewModel.isLoading,
                        isComplete: viewModel.isComplete,
                        isDisabled: interactionLocked || !allowInteraction,
                        result: viewModel.result,
                        showShimmer: !allowInteraction,
                        shimmerOffset: shimmerOffset,
                        onComplete: {
                            interactionLocked = true

                            Task {
                                await viewModel.approve()
                                if let result = viewModel.result {
                                    onComplete(result)

                                    try? await Task.sleep(nanoseconds: 800_000_000)

                                    await MainActor.run {
                                        coordinator.goBack()
                                    }
                                }
                            }
                        },
                        onSlideComplete: {
                            interactionLocked = true
                            viewModel.markSlideComplete()
                        }
                    )
                    .id(sliderKey)
                }
                .padding(.horizontal, AppTheme.paddingSmall)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
            }
            .blur(radius: viewModel.isLoading ? 4 : 0)

            if viewModel.isLoading {
                ProcessingOverlayView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            interactionLocked = false
            allowInteraction = false
            shimmerOffset = -200
            viewModel.reset()
            sliderKey = UUID()

            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showContent = true
                cardScale = 1.0
            }

            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    allowInteraction = true
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
        .onChange(of: viewModel.isLoading) { loading in
            if loading {
                interactionLocked = true
            }
        }
    }
}
