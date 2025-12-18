//
//  RequestDetailViewModelTests.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import XCTest
@testable import RequestProcessing

// MARK: - Test Suite

@MainActor
class RequestDetailViewModelTests: XCTestCase {
    var viewModel: RequestDetailViewModel!
    var mockService: MockRequestServiceForTesting!

    override func setUp() {
        super.setUp()
        mockService = MockRequestServiceForTesting()
        viewModel = RequestDetailViewModel(
            request: Request.mockRequest,
            service: mockService
        )
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    // MARK: - Approval Success Tests

    func testApprovalSuccess() async {
        // Given
        mockService.approvalResult = .success(.approve)

        // When
        await viewModel.approve()

        // Then
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
        XCTAssertTrue(viewModel.isComplete, "Should mark as complete")
        XCTAssertNil(viewModel.errorMessage, "Should have no error message")

        if case .success(let action) = viewModel.result {
            XCTAssertEqual(action, .approve, "Action should be approve")
        } else {
            XCTFail("Expected success result with approve action")
        }
    }

    // MARK: - Approval Failure Tests

    func testApprovalFailureWithResult() async {
        // Given
        mockService.approvalResult = .failure("Network error")

        // When
        await viewModel.approve()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isComplete)

        if case .failure(let message) = viewModel.result {
            XCTAssertEqual(message, "Network error")
        } else {
            XCTFail("Expected failure result")
        }
    }

    func testApprovalThrowsError() async {
        // Given
        mockService.shouldThrowOnApproval = true
        mockService.errorToThrow = RequestServiceError.approvalFailed("Server error")

        // When
        await viewModel.approve()

        // Then
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after error")
        XCTAssertNotNil(viewModel.errorMessage, "Should have error message")

        if case .failure = viewModel.result {
            XCTAssertTrue(true, "Result should be failure")
        } else {
            XCTFail("Expected failure result when service throws")
        }
    }

    // MARK: - Rejection Tests

    func testRejectionSuccess() async {
        // Given
        mockService.rejectionResult = .success(.reject)

        // When
        await viewModel.reject()

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.isComplete)
        XCTAssertNil(viewModel.errorMessage)

        if case .success(let action) = viewModel.result {
            XCTAssertEqual(action, .reject, "Action should be reject")
        } else {
            XCTFail("Expected success result with reject action")
        }
    }

    // MARK: - Loading State Tests

    func testLoadingStateDuringApproval() async {
        // Given
        mockService.approvalDelay = 100_000_000

        // When
        let task = Task {
            await viewModel.approve()
        }

        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then
        XCTAssertTrue(viewModel.isLoading, "Should be loading during async operation")

        await task.value
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
    }

    func testLoadingStateDuringRejection() async {
        // When
        XCTAssertFalse(viewModel.isLoading, "Should not be loading initially")

        let task = Task {
            await viewModel.reject()
        }

        await task.value

        // Then
        XCTAssertFalse(viewModel.isLoading, "Should not be loading after completion")
    }

    // MARK: - Reset Tests

    func testResetClearsAllState() async {
        // Given
        mockService.approvalResult = .success(.approve)
        await viewModel.approve()

        XCTAssertTrue(viewModel.isComplete, "Should be complete before reset")
        XCTAssertNotNil(viewModel.result, "Should have result before reset")

        // When
        viewModel.reset()

        // Then
        XCTAssertFalse(viewModel.isLoading, "Loading should be false")
        XCTAssertFalse(viewModel.isComplete, "Complete should be false")
        XCTAssertFalse(viewModel.isSlideComplete, "Slide complete should be false")
        XCTAssertNil(viewModel.result, "Result should be nil")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil")
    }

    // MARK: - Slide Complete Tests

    func testMarkSlideComplete() {
        // Given
        XCTAssertFalse(viewModel.isSlideComplete)

        // When
        viewModel.markSlideComplete()

        // Then
        XCTAssertTrue(viewModel.isSlideComplete)
    }

    // MARK: - Error Message Tests

    func testErrorMessageSetOnFailure() async {
        // Given
        let expectedError = "Custom error message"
        mockService.shouldThrowOnApproval = true
        mockService.errorToThrow = NSError(
            domain: "Test",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: expectedError]
        )

        // When
        await viewModel.approve()

        // Then
        XCTAssertEqual(viewModel.errorMessage, expectedError)
    }
}
