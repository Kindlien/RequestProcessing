//
//  AppTheme.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

struct AppTheme {
    static let primaryTeal = Color(hex: "285976")
    static let lightTeal = Color(hex: "87D6CD")
    static let secondaryTeal = Color(hex: "87E1ED")
    static let backgroundLight = Color(hex: "EFFCFF")
    static let backgroundDark = Color(hex: "165868")
    static let errorRed = Color(hex: "FFABAB")
    static let errorTextRed = Color(hex: "285976")
    static let successTextGreen = Color(hex: "285976")
    static let successTextDarkBlue = Color(hex: "0B2545")

    static let titleFont: Font = .system(size: 48, weight: .bold)
    static let headlineFont: Font = .system(size: 40, weight: .bold)
    static let bodyFont: Font = .system(size: 14, weight: .regular)
    static let buttonFont: Font = .system(size: 18, weight: .semibold)
    static let mainButtonFont: Font = .system(size: 15, weight: .regular)
    static let cardTitleFont: Font = .system(size: 16, weight: .bold)

    static let paddingLarge: CGFloat = 40
    static let paddingMedium: CGFloat = 24
    static let paddingSmallMedium: CGFloat = 21
    static let paddingSmall: CGFloat = 16
    static let paddingExtraSmall: CGFloat = 13.5
    static let cornerRadiusLarge: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    static let cornerRadiusSmall: CGFloat = 4
    static let buttonHeight: CGFloat = 48
}
