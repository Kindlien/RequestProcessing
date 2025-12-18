//
//  Request.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct Request: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String

    static let mockRequest = Request(
        id: UUID().uuidString,
        title: "Heading 1",
        description: "Lorem ipsum dolor sit amet consectetur. Arcu tincidunt vitae cras amet. Blandit id sed et est gravida. Eu sapien amet et volutpat ultrices sed. Euismod semper mi non vitae egestas sollicitudin aliquam."
    )
}
