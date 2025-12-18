//
//  LoadingDotsView.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct LoadingDotsView: View {
    @State private var animatingDots = [false, false, false]

    var body: some View {
        HStack(spacing: 8) {
            Text("Loading")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(.white)
                        .frame(width: 6, height: 6)
                        .opacity(animatingDots[index] ? 1 : 0.3)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: animatingDots[index]
                        )
                }
            }
        }
        .onAppear {
            for i in 0..<3 {
                animatingDots[i] = true
            }
        }
    }
}
