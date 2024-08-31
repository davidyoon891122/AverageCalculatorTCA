//
//  ToastModel.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/31/24.
//

import Foundation

struct ToastModel: Equatable {

    var style: ToastStyleType
    var message: String
    var duration: Double = 3.0
    var width: Double = .infinity

}
