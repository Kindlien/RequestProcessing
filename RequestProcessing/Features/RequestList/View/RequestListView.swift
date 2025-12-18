//
//  RequestListView.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct RequestListView: View {
    @StateObject private var coordinator = MainCoordinator()
    @StateObject private var viewModel = RequestListViewModel()
    @State private var returnedResult: RequestResult?
    @State private var showContent = false
    @State private var buttonScale: CGFloat = 0.9

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                AppTheme.backgroundLight
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("Home")
                            .font(AppTheme.headlineFont)
                            .foregroundColor(AppTheme.primaryTeal)
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.paddingLarge)
                    .padding(.top, 63)
                    .padding(.bottom, 80)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                    Circle()
                        .fill(.white)
                        .frame(width: 238, height: 238)
                        .overlay(
                            Image("ic_Via")
                                .resizable()
                                .frame(width: 130, height: 43)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 25, y: 12)
                        .scaleEffect(showContent ? 1 : 0.8)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        .padding(.bottom, 68)

                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            buttonScale = 0.95
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                buttonScale = 1.0
                            }
                            coordinator.showRequestDetail(Request.mockRequest)
                        }
                    } label: {
                        Text("Create new request")
                            .font(AppTheme.mainButtonFont)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppTheme.buttonHeight)
                            .background(
                                LinearGradient(
                                    colors: [AppTheme.primaryTeal, AppTheme.primaryTeal.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(AppTheme.cornerRadius)
                            .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                            .stroke(AppTheme.lightTeal, lineWidth: 1)
                                    )
                            .shadow(color: AppTheme.primaryTeal.opacity(0.4), radius: 12, y: 6)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.horizontal, AppTheme.paddingLarge)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)


                    Spacer()
                }

                if let message = viewModel.toastMessage,
                   let type = viewModel.toastType {
                    ToastView(
                        message: message,
                        type: type,
                        hasIcon: false,
                        onDismiss: {
                            viewModel.toastMessage = nil
                            viewModel.toastType = nil
                        }
                    )
                }
            }
            .navigationDestination(for: MainCoordinator.Destination.self) { destination in
                switch destination {
                case .requestDetail(let request):
                    RequestDetailView(
                        viewModel: RequestDetailViewModel(request: request),
                        coordinator: coordinator,
                        onComplete: { result in
                            returnedResult = result
                        }
                    )
                }
            }
            .onChange(of: coordinator.path.count) { oldCount, newCount in
                if newCount == 0, let result = returnedResult {
                    viewModel.showToast(result: result)
                    returnedResult = nil
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                buttonScale = 1.0
            }
        }
    }
}
