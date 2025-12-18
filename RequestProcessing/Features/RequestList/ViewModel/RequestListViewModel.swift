//
//  RequestListViewModel.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

@MainActor
class RequestListViewModel: ObservableObject {
    @Published var toastMessage: String?
    @Published var toastType: ToastType?

    func showToast(result: RequestResult) {
        switch result {
        case .success(let action):
            if action == .approve {
                toastType = .success
                toastMessage = "Request approved"
            } else {
                toastType = .error
                toastMessage = "Request rejected"
            }
        case .failure(let message):
            toastType = .error
            toastMessage = message
        }

        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation(.easeOut(duration: 0.3)) {
                toastMessage = nil
                toastType = nil
            }
        }
    }
}
