//
//  RequestServiceError.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

enum RequestServiceError: LocalizedError {
    case approvalFailed(String)
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .approvalFailed(let message):
            return message
        case .networkError:
            return "Network connection failed"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
