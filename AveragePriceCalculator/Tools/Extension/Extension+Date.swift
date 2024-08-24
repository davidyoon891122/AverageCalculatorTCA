//
//  Extension+Date.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/24/24.
//

import Foundation

enum DateFormatType {

    case `default`

    var format: String {
        switch self {
        case .default:
            return "yyyy-MM-dd"
        }
    }

}

extension Date {

    func getStringDateByFormat(type: DateFormatType = .default) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.format

        return dateFormatter.string(from: self)
    }

}
