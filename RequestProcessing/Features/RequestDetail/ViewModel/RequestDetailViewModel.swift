//
//  RequestDetailViewModel.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

@MainActor
class RequestDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isComplete = false
    @Published var isSlideComplete = false
    @Published var result: RequestResult?
    @Published var errorMessage: String?

    let request: Request
    private let service: RequestService

    init(request: Request, service: RequestService = MockRequestService()) {
        self.request = request
        self.service = service
    }

    func approve() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        errorMessage = nil

        do {
            let result = try await service.processApproval()
            self.result = result
            isComplete = true
        } catch {
            errorMessage = error.localizedDescription
            self.result = .failure(error.localizedDescription)
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = false
        }
    }

    func reject() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
        }
        errorMessage = nil

        do {
            let result = try await service.processRejection()
            self.result = result
            isComplete = true
        } catch {
            errorMessage = error.localizedDescription
            self.result = .failure(error.localizedDescription)
        }

        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = false
        }
    }

    func markSlideComplete() {
        isSlideComplete = true
    }

    func reset() {
        isLoading = false
        isComplete = false
        isSlideComplete = false
        result = nil
        errorMessage = nil
    }
}
