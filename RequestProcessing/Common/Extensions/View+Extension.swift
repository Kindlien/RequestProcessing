//
//  View+Extension.swift
//  RequestProcessing
//
//  Created by William Kindlien Gunawan on 18/12/25.
//

import SwiftUI

extension View {
    func toast(
        message: Binding<String?>,
        type: Binding<ToastType?>,
        hasIcon: Bool = true
    ) -> some View {
        ZStack {
            self

            if let msg = message.wrappedValue, let toastType = type.wrappedValue {
                ToastView(
                    message: msg,
                    type: toastType,
                    hasIcon: hasIcon,
                    onDismiss: {
                        message.wrappedValue = nil
                        type.wrappedValue = nil
                    }
                )
            }
        }
    }
}
