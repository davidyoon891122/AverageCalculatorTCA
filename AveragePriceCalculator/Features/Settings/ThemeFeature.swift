//
//  ThemeFeature.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 9/6/24.
//

import SwiftUI
import ComposableArchitecture

enum ThemeType: String, CaseIterable, Identifiable, Equatable {
    
    case dark
    case light
    case system
    
    var id: Self { self }
    
    var name: String {
        rawValue.capitalized
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
    
}

@Reducer
struct ThemeFeature {
    
    @ObservableState
    struct State: Equatable {
        let navigationTitle: String = "Theme Settings"
        var currentTheme: ThemeType = .system
    }
    
    enum Action {
        case onAppear
        case setTheme(ThemeType)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .setTheme(theme):
                state.currentTheme = theme
                return .none
            }
        }
    }
    
}

import SwiftUI

struct ThemeSettingView: View {
    
    @Perception.Bindable var store: StoreOf<ThemeFeature>
    @State private var selectedTheme: ThemeType = .system
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Current Theme: \(store.currentTheme.name)")
                        .bold()
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.horizontal)
                ThemePicker(selection: $store.currentTheme.sending(\.setTheme))
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationTitle(store.navigationTitle)
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
