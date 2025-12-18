//
//  RequestProcessingApp.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 17/12/25.
//

import SwiftUI

@main
struct RequestProcessingApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView(onComplete: {
                        showSplash = false
                    })
                } else {
                    RequestListView()
                        .transition(.opacity)
                }
            }
        }
    }
}
