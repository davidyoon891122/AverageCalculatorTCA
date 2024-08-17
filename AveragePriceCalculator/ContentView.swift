//
//  ContentView.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    let store: StoreOf<DisplayListFeature>

    var body: some View {
        DisplayListView(store: store)
    }
}

#Preview {
    ContentView(store: Store(initialState: DisplayListFeature.State()) {
        DisplayListFeature()
    })
}
