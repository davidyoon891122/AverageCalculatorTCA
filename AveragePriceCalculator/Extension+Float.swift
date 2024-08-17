//
//  Extension+Float.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation

extension Float {

    func displayDecimalPlace(by: Int) -> String {
        String(format: "%.\(by)f", self)
    }

}
