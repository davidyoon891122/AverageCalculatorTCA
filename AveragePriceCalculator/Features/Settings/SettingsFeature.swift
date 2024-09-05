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
        let menus: [String] = ["Theme", "Help", "Report"]
    }

    enum Action {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }

}

import SwiftUI

struct SettingsView: View {

    let store: StoreOf<SettingsFeature>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.menus, id: \.self) { menu in
                    Text("\(menu)")
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
            .navigationTitle(store.navigationTitle)
        }
    }

}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
    })
}
