//
//  MockRequestServiceForTesting.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import XCTest
@testable import RequestProcessing

class MockRequestServiceForTesting: RequestService {
    var shouldThrowOnApproval = false
    var shouldThrowOnRejection = false
    var approvalResult: RequestResult = .success(.approve)
    var rejectionResult: RequestResult = .success(.reject)
    var approvalDelay: UInt64 = 0
    var errorToThrow: Error?

    func processApproval() async throws -> RequestResult {
        if approvalDelay > 0 {
            try await Task.sleep(nanoseconds: approvalDelay)
        }

        if shouldThrowOnApproval {
            throw errorToThrow ?? RequestServiceError.approvalFailed("Test error")
        }

        return approvalResult
    }

    func processRejection() async throws -> RequestResult {
        if shouldThrowOnRejection {
            throw errorToThrow ?? RequestServiceError.networkError
        }

        return rejectionResult
    }
}
