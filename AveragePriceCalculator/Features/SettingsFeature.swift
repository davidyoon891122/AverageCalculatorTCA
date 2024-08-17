//
//  SettingsFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import ComposableArchitecture

@Reducer
struct SettingsFeature {

    @ObservableState
    struct State: Equatable {
        let navigationTitle = "Settings"
    }

    enum Action {

    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            }
        }
    }

}

import SwiftUI

struct SettingsView: View {

    let store: StoreOf<SettingsFeature>

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to the Settings")
            }
            .navigationTitle(store.navigationTitle)
        }
    }

}

