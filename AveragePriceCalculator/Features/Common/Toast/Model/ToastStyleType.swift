//
//  ToastStyleType.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/31/24.
//

import SwiftUI

enum ToastStyleType {

    case error
    case warning
    case success
    case info

}

extension ToastStyleType {

    var themeColor: Color {
        switch self {
        case .error:
            .red
        case .warning:
            .yellow
        case .success:
            .blue
        case .info:
            .green
        }
    }

    var icon: String {

        switch self {
        case .error:
            "xmark.circle.fill"
        case .warning:
            "exclamationmark.triangle.fill"
        case .success:
            "checkmark.circle.fill"
        case .info:
            "info.circle.fill"
        }
    }

}
