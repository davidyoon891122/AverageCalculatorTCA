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
    var firstPrice: Double
    var firstQuantity: Double
    var secondPrice: Double
    var secondQuantity: Double

}

extension AverageCalculatorModel {

    var averagePrice: Double {
        ((self.firstPrice * self.firstQuantity) + (self.secondPrice * self.secondQuantity)) / (self.firstQuantity + self.secondQuantity)
    }

}
