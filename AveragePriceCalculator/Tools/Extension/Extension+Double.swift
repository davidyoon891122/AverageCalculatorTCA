//
//  Extension+Double.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation

extension Double {

    func displayDecimalPlace(by: Int) -> String {
        String(format: "%.\(by)f", self)
    }
    
    func displayFormattedStringByPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if self > 1 {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            if let formattedNumber = formatter.string(from: NSNumber(floatLiteral: self)) {
                return formattedNumber
            } else {
                return "\(self)"
            }
        } else {
            formatter.minimumFractionDigits = 6
            formatter.maximumFractionDigits = 6
            if let formattedNumber = formatter.string(from: NSNumber(floatLiteral: self)) {
                return formattedNumber
            } else {
                return "\(self)"
            }
        }
    }

}
