//
//  AveragePriceCalculatorApp.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct AveragePriceCalculatorApp: App {

    static let store = Store(initialState: DisplayListFeature.State()) {
        DisplayListFeature()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(store: AveragePriceCalculatorApp.store)
        }
    }
}
