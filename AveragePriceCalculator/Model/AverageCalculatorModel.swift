//
//  AverageCalculatorModel.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/18/24.
//

import Foundation

struct AverageCalculatorModel: Codable, Identifiable, Equatable {

    let id: UUID
    var name: String
    var firstPrice: Float
    var firstQuantity: Double
    var secondPrice: Float
    var secondQuantity: Double

}

extension AverageCalculatorModel {

    var averagePrice: Float {
        ((self.firstPrice * Float(self.firstQuantity)) + (self.secondPrice * Float(self.secondQuantity))) / Float((self.firstQuantity + self.secondQuantity))
    }

}
