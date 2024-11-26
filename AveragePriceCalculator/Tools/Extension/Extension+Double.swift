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
            formatter.minimumFractionDigits = 8
            formatter.maximumFractionDigits = 8
            if let formattedNumber = formatter.string(from: NSNumber(floatLiteral: self)) {
                return formattedNumber
            } else {
                return "\(self)"
            }
        }
    }
    
    var commaFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formatterValue = formatter.string(from: NSNumber(floatLiteral: self)) {
            return formatterValue
        } else {
            return "\(self)"
        }
        
    }

}

extension Decimal {
    
    var commaFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formatterValue = formatter.string(from: NSDecimalNumber(decimal: self)) {
            return formatterValue
        } else {
            return "\(self)"
        }
        
    }
    
}
