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
        if let doubleValue = Double(self) {
            return doubleValue.commaFormat
        } else {
            return self
        }
        
    }
    
}
