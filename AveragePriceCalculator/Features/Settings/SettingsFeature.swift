//
//  SettingsFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import ComposableArchitecture

@Reducer
struct SettingsFeature {
    
    @Reducer(state: .equatable)
    enum Path {
        case theme(ThemeFeature)
    }

    @ObservableState
    struct State: Equatable {
        let navigationTitle = "Settings".localized()
        let menus: [SettingsMenuType] = SettingsMenuType.allCases
        var path = StackState<Path.State>()
        
        @Presents var reportFeatureState: ReportFeature.State?
        
        @Shared(.appStorage("theme")) var theme: ThemeType = .system
    }

    enum Action {
        case onAppear
        case didTapMenu(SettingsMenuType)
        case path(StackActionOf<Path>)
        case reportAction(PresentationAction<ReportFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print(state.theme)
                return .none
            case .didTapMenu(let menu):
                switch menu {
                case .theme:
                    state.path.append(.theme(ThemeFeature.State()))
                case .report:
                    state.reportFeatureState = ReportFeature.State()
                }
                return .none
            case .path:
                return .none
            case .reportAction:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$reportFeatureState, action: \.reportAction) {
            ReportFeature()
        }
    }

}

import SwiftUI

struct SettingsView: View {

    @Perception.Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(store.menus, id: \.self) { menu in
                                MenuView(title: menu.title)
                                    .onTapGesture {
                                        store.send(.didTapMenu(menu))
                                    }
                                
                            }
                        }
                    }
                    .onAppear {
                        store.send(.onAppear)
                    }
                    .preferredColorScheme(store.theme.colorScheme)
                    .navigationTitle(store.navigationTitle)
                    AdmobBannerView()
                        .frame(height: 90.0)
                }
                .sheet(item: $store.scope(state: \.reportFeatureState, action: \.reportAction)) { reportStore in
                    ReportView()
                }
            } destination: { store in
                switch store.case {
                case let .theme(store):
                    ThemeSettingView(store: store)
                }
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

struct MenuView: View {
    
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title)")
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
            }
            Divider()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 8)
        .padding(.horizontal)
        .tint(.gray)
    }
    
}
