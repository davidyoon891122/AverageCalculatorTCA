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
    var date: String
    var firstPrice: Double
    var firstQuantity: Double
    var secondPrice: Double
    var secondQuantity: Double

}


extension ItemModel {

    var averagePrice: Double {
        ((self.firstPrice * self.firstQuantity) + (self.secondPrice * self.secondQuantity)) / (self.firstQuantity + self.secondQuantity)
    }

}

extension ItemModel {

    static let preview: Self = .init(id: UUID(), name: "BitCoin", date: Date().getStringDateByFormat(), firstPrice: 82000000, firstQuantity: 1, secondPrice: 70000000, secondQuantity: 1)

}
