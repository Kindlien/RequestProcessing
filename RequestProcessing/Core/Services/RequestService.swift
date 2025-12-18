//
//  RequestService.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

protocol RequestService {
    func processApproval() async throws -> RequestResult
    func processRejection() async throws -> RequestResult
}
