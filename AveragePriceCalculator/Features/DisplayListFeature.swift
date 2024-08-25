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
    struct State: Equatable {
        @Presents var addItem: AddItemFeature.State?
        var path = StackState<ItemDetailFeature.State>()
        var items: [ItemModel] = []
        var isLoading = false
        let navigationTitle = "Average Calculator"
    }

    enum Action {
        case onAppear
        case refresh
        case addButtonTapped
        case addItem(PresentationAction<AddItemFeature.Action>)
        case listElementTapped
        case loadList([ItemModel])
        case path(StackAction<ItemDetailFeature.State, ItemDetailFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let items = UserDefaultsManager().loadItems()

                return .send(.loadList(items))
            case .refresh:
                state.isLoading = true
                let items = UserDefaultsManager().loadItems()

                return .send(.loadList(items))
            case .addButtonTapped:
                state.addItem = AddItemFeature.State()
                return .none
            case .listElementTapped:
                return .none
            case .loadList(let items):
                state.items = items
                state.isLoading = false
                return .none
            case .addItem:
                let items = UserDefaultsManager().loadItems()
                return .send(.loadList(items))
            case .path(_):
                return .none
            }
        }
        .ifLet(\.$addItem, action: \.addItem) {
            AddItemFeature()
        }
        .forEach(\.path, action: \.path) {
            ItemDetailFeature()
        }
    }

}

import SwiftUI

struct DisplayListView: View {

    @Perception.Bindable var store: StoreOf<DisplayListFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ZStack {
                    ScrollView {
                        VStack {
                            LazyVStack {
                                ForEach(store.items) { item in
                                    NavigationLink(state: ItemDetailFeature.State(item: item)) {
                                        ItemView(item: item)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    store.send(.addButtonTapped)
                                }, label: {
                                    Image(systemName: "plus.circle")
                                })
                            }
                        }
                    }
                    .refreshable {
                        store.send(.refresh)
                    }
                    if store.isLoading {
                        ProgressView()
                    }
                }
                .onAppear {
                    store.send(.onAppear)
                }
                .sheet(
                    item: $store.scope(state:\.addItem, action: \.addItem)
                ) { addItemStore in
                    NavigationStack {
                        AddItemView(store: addItemStore)
                    }
                }
                .navigationTitle(store.navigationTitle)
            } destination: { store in
                ItemDetailView(store: store)
            }
        }
    }

}

#Preview {
    DisplayListView(store: Store(initialState: DisplayListFeature.State(items: [
        .init(id: UUID(), name: "test", date: "2024-11-22", firstPrice: 100, firstQuantity: 10, secondPrice: 90, secondQuantity: 8)])) {
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
            }

            Divider()
        }
        .padding(.horizontal)
        .padding(.vertical)

    }
}
