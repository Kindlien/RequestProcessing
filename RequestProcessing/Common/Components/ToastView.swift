//
//  ToastType.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

// MARK: - Toast Type

enum ToastType {
    case success
    case error

    var backgroundColor: Color {
        switch self {
        case .success: return AppTheme.lightTeal
        case .error: return AppTheme.errorRed
        }
    }

    var textColor: Color {
        switch self {
        case .success: return AppTheme.successTextGreen
        case .error: return AppTheme.errorTextRed
        }
    }

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

// MARK: - Toast View

struct ToastView: View {
    let message: String
    let type: ToastType
    let hasIcon: Bool
    let onDismiss: () -> Void

    init(
        message: String,
        type: ToastType,
        hasIcon: Bool = true,
        onDismiss: @escaping () -> Void
    ) {
        self.message = message
        self.type = type
        self.hasIcon = hasIcon
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 12) {
                if hasIcon {
                    Image(systemName: type.icon)
                        .font(.system(size: 20))
                        .foregroundColor(type.textColor)
                }

                Text(message)
                    .font(AppTheme.mainButtonFont)
                    .foregroundColor(type.textColor)
                    .lineLimit(2)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        onDismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 14.5, height: 14.5)
                        .foregroundColor(type.textColor)
                }
            }
            .padding(.horizontal, AppTheme.paddingSmallMedium)
            .padding(.vertical, 20)
            .background(type.backgroundColor)
            .cornerRadius(AppTheme.cornerRadiusSmall)
            .padding(.horizontal, AppTheme.paddingSmall)
            .padding(.bottom, 20)
            .shadow(
                color: Color.black.opacity(0.16),
                radius: 3,
                x: 0,
                y: 3
            )
            .transition(.asymmetric(
                insertion: .move(edge: .bottom)
                    .combined(with: .opacity)
                    .combined(with: .scale(scale: 0.9)),
                removal: .move(edge: .bottom)
                    .combined(with: .opacity)
            ))
        }
    }
}
