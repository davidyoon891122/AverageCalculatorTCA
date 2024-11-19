//
//  SettingsMenuType.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 9/5/24.
//

import Foundation

enum SettingsMenuType: CaseIterable {
    
    case theme
//    case help
//    case report
    
    var title: String {
        switch self {
        case .theme:
            "Theme"
        }
    }
    
}

