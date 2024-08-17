//
//  DisplayListFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/17/24.
//

import ComposableArchitecture

@Reducer
struct DisplayListFeature {

    @ObservableState
    struct State {
        var items: [ItemModel] = []
        var isLoading = false
        let navigationTitle = "Average Calculator"
    }

    enum Action {
        case viewAppear
        case refresh
        case addButtonTapped
        case listElementTapped
        case loadList([ItemModel])
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .viewAppear:
                state.isLoading = true
                state.items = UserDefaultsManager().loadItems()

                return .none
            case .refresh:
                state.isLoading = true
                state.items = UserDefaultsManager().loadItems()

                return .none
            case .addButtonTapped:
                return .none
            case .listElementTapped:
                return .none
            case .loadList(let items):
                return .none
            }
        }
    }

}

import SwiftUI

struct DisplayListView: View {

    let store: StoreOf<DisplayListFeature>

    var body: some View {

        VStack {
            LazyVStack {
                ForEach(store.items) { item in
                    ItemView(item: item)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // TODO: - Move to AddView
                }, label: {
                    Image(systemName: "plus.circle")
                })
            }
        }
        .navigationTitle(store.navigationTitle)
    }

}

#Preview {
    DisplayListView(store: Store(initialState: DisplayListFeature.State(items: [
        .init(id: UUID(), name: "Bitcoin", date: "2024-08-17", profitRage: 30.0, price: 82000000, quantity: 1)])) {
        DisplayListFeature()
    }
    )
}

struct ItemView: View {

    let item: ItemModel

    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                    .bold()
                    .font(.system(size: 22.0))
                Spacer()
                Text(item.averagePrice.displayDecimalPlace(by: 2))
                    .bold()
                    .font(.system(size: 28.0))
            }
            HStack {
                Text(item.date)
                    .foregroundStyle(.gray)
                Spacer()
                Text("profit: ")
                Text(item.profitRage.displayDecimalPlace(by: 2) + "%")
                    .bold()
            }
        }
        .padding(.horizontal)
    }
}
