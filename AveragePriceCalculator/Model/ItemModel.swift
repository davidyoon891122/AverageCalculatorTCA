//
//  ItemModel.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation

struct ItemModel: Codable, Identifiable, Equatable {

    let id: UUID
    var name: String
    let date: String
    let firstPrice: Double
    let firstQuantity: Double
    let secondPrice: Double
    let secondQuantity: Double

}


extension ItemModel {

    var averagePrice: Double {
        ((self.firstPrice * self.firstQuantity) + (self.secondPrice * self.secondQuantity)) / (self.firstQuantity + self.secondQuantity)
    }

}
