//
//  ItemModel.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation
import SwiftUI

struct ItemModel: Codable, Identifiable, Equatable {

    let id: UUID
    var name: String
    var date: String
    var firstPrice: Decimal
    var firstQuantity: Decimal
    var secondPrice: Decimal
    var secondQuantity: Decimal

}


extension ItemModel {

    var averagePrice: String {
        let result = ((self.firstPrice * self.firstQuantity) + (self.secondPrice * self.secondQuantity)) / (self.firstQuantity + self.secondQuantity)
        if result > 1 {
            return String(format: "%.3f", NSDecimalNumber(decimal: result).doubleValue).commaFormat
        } else {
            return String(format: "%.8f", NSDecimalNumber(decimal: result).doubleValue).commaFormat
        }
    }
    
    var profit: String {
        let firstValuePrice = firstPrice * firstQuantity
        let secondValuePrice = secondPrice * secondQuantity
        
        let totalPrice = firstValuePrice + secondValuePrice
        
        let currentPriceValue = secondPrice * (firstQuantity + secondQuantity)

        let result = ((currentPriceValue - totalPrice) / totalPrice) * 100

        return String(format: "%.2f", NSDecimalNumber(decimal: result).doubleValue)
    }
    
    var profitColor: Color {
        Double(self.profit) ?? 0.0 > 0 ? .red : .blue
    }

    var totalPurchasePrice: String {
        let result = (self.firstPrice * self.firstQuantity) + (self.secondPrice * self.secondQuantity)
        return result.commaFormat
    }

}

extension ItemModel {

    static let preview: Self = .init(id: UUID(), name: "BitCoin", date: Date().getStringDateByFormat(), firstPrice: 82000000, firstQuantity: 1, secondPrice: 70000000, secondQuantity: 1)

}
