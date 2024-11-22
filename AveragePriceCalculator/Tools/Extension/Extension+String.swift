//
//  Extension+String.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/20/24.
//

import Foundation

extension String {
    
    var commaStringtoDouble: Double {
        let replacedString = self.replacingOccurrences(of: ",", with: "")
        
        if let doubleValue = Double(replacedString) {
            return doubleValue
        } else {
            return 0
        }
    }
    
    var commaFormat: String {
        let filtered = self.filter { "0123456789.".contains($0) }
        let components = filtered.components(separatedBy: ".")
        
        if components.count > 1 {
            let integerPart = components[0]
            let decimalPart = components[1]
            
            if let integerValue = Double(integerPart) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedInteger = formatter.string(from: NSNumber(value: integerValue)) ?? integerPart
                
                return "\(formattedInteger).\(decimalPart)"
            }
            return filtered
            
        } else {
            if let doubleValue = Double(filtered) {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                return formatter.string(from: NSNumber(value: doubleValue)) ?? filtered
            }
            return filtered
        }
    }
    
}

// MARK: - Localized
extension String {

    func localized() -> String {
        return NSLocalizedString(self, value: self, comment: "")
    }

}
