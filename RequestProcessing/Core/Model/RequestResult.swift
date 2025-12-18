//
//  RequestResult.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

enum RequestResult: Equatable {
    case success(RequestAction)
    case failure(String)
}
