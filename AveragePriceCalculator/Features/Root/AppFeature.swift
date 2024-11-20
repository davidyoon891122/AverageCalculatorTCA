//
//  AppFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var tab1 = DisplayListFeature.State()
        var tab2 = SettingsFeature.State()
        
        @Shared(.appStorage("theme")) var theme: ThemeType = .system
    }

    enum Action {
        case tab1(DisplayListFeature.Action)
        case tab2(SettingsFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            DisplayListFeature()
        }

        Scope(state: \.tab2, action: \.tab2) {
            SettingsFeature()
        }

        Reduce { state, action in
            return .none
        }
    }
}
