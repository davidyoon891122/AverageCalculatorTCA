//
//  ThemeFeature.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 9/6/24.
//

import SwiftUI
import ComposableArchitecture

enum ThemeType: String, CaseIterable, Identifiable, Equatable, Codable {
    
    case dark
    case light
    case system
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .dark:
            "Dark".localized()
        case .light:
            "Light".localized()
        case .system:
            "System".localized()
        }
    }
    
    var color: Color {
        switch self {
        case .dark:
            .black
        case .light:
            .white
        case .system:
            .gray
        }
    }
    
    var imageName: String {
        switch self {
        case .dark:
            "moon"
        case .light:
            "sun.max"
        case .system:
            "apple.logo"
        }
    }
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .dark:
            .black
        case .light:
            .white
        case .system:
            scheme == .dark ? .black : .white
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .dark:
            .dark
        case .light:
            .light
        case .system:
            nil
        }
    }
    
}

@Reducer
struct ThemeFeature {
    
    @ObservableState
    struct State: Equatable {
        let navigationTitle: String = "Theme Settings".localized()
        @Shared(.appStorage("theme")) var theme: ThemeType = .system
    }
    
    enum Action: BindableAction {
        case onAppear
        case setTheme(ThemeType)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .setTheme(theme):
                state.theme = theme
                print(state.theme)
                return .none
            case .binding:
                return .none
            }
        }
    }
    
}

import SwiftUI

struct ThemeSettingView: View {
    
    @Perception.Bindable var store: StoreOf<ThemeFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Current Theme: \(store.theme.name)")
                                .bold()
                                .font(.system(size: 20.0))
                            Spacer()
                        }
                        .padding(.horizontal)
                        ThemePicker(selection: $store.theme.sending(\.setTheme))
                    }
                }
                .preferredColorScheme(store.theme.colorScheme)
                .onAppear {
                    store.send(.onAppear)
                }
                .navigationTitle(store.navigationTitle)
//                AdmobBannerView()
//                    .frame(height: 90.0)
            }
        }
    }
    
}

#Preview {
    ThemeSettingView(store: Store(initialState: ThemeFeature.State()) {
        ThemeFeature()
    })
}

struct ThemePicker: View {
    
    @Binding var selection: ThemeType
    
    var body: some View {
        HStack {
            ForEach(ThemeType.allCases) { theme in
                HStack {
                    Text("\(theme.name)")
                        .bold()
                        .font(.system(size: 16))
                    Image(systemName: theme.imageName)
                }
                .padding()
                .frame(width: (UIScreen.main.bounds.width / CGFloat(ThemeType.allCases.count)) - 16, height: 50)
                .border(theme == selection ? .blue : .gray)
                .tag(theme)
                .background(theme == selection ? .gray : .white)
                .foregroundStyle(theme == selection ? .white : .black)
                .onTapGesture {
                    selection = theme
                }
            }
        }
        .padding()
        
    }
}
