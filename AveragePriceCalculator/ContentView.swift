//
//  ContentView.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            DisplayListView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Display")
                }

            SettingsView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .preferredColorScheme(store.theme.colorScheme)
    }
}

#Preview {
    ContentView(store: AveragePriceCalculatorApp.store)
}
