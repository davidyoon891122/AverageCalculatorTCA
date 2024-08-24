//
//  Extension+Double.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation

extension Double {

    func displayDecimalPlace(by: Int) -> String {
        String(format: "%.\(by)f", self)
    }

}
