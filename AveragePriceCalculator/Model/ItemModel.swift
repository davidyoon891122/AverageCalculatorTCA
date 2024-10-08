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
    let profitRage: Float
    let price: Float
    let quantity: Double

}


extension ItemModel {

    var averagePrice: Float {
        self.price * Float(self.quantity)
    }

}
