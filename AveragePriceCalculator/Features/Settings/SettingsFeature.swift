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
        var path = StackState<ThemeFeature.State>()
        @Shared(.appStorage("theme")) var theme: ThemeType = .system
    }

    enum Action {
        case onAppear
        case path(StackAction<ThemeFeature.State, ThemeFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print(state.theme)
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            ThemeFeature()
        }
    }

}

import SwiftUI

struct SettingsView: View {

    @Perception.Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ScrollView {
                    LazyVStack {
                        ForEach(store.menus, id: \.self) { menu in
                            NavigationLink(state: ThemeFeature.State(theme: store.$theme)) {
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
                }
                .onAppear {
                    store.send(.onAppear)
                }
                .preferredColorScheme(store.theme.colorScheme)
                .navigationTitle(store.navigationTitle)
            } destination: { store in
                ThemeSettingView(store: store)
            }
        }
    }

}

#Preview {
    NavigationStack {
        SettingsView(store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        })
    }
}
