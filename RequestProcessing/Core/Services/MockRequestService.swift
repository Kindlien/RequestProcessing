//
//  MockRequestService.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

class MockRequestService: RequestService {
    func processApproval() async throws -> RequestResult {
        try await Task.sleep(nanoseconds: 2_000_000_000)

        if Bool.random() {
            throw RequestServiceError.approvalFailed("Approval failed. Please try again.")
        }

        return .success(.approve)
    }

    func processRejection() async throws -> RequestResult {
        return .success(.reject)
    }
}
