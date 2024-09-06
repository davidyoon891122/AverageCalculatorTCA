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
        let menus: [SettingsMenuType] = SettingsMenuType.allCases
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
            ScrollView {
                LazyVStack {
                    ForEach(store.menus, id: \.self) { menu in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(menu.title)")
                                    .bold()
                            }
                            Divider()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                    }
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
