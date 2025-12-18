//
//  MainCoordinator.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

@MainActor
class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    enum Destination: Hashable {
        case requestDetail(Request)
    }

    func showRequestDetail(_ request: Request) {
        path.append(Destination.requestDetail(request))
    }

    func dismissToRoot(with result: RequestResult? = nil) {
        path.removeLast(path.count)
    }

    func goBack(with result: RequestResult? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.path.isEmpty {
                self.path.removeLast()
            }
        }
    }
}
