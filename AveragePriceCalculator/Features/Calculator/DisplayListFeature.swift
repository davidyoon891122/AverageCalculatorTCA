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
        let navigationTitle = "Average Calculator".localized()
    }

    enum Action {
        case onAppear
        case refresh
        case addButtonTapped
        case addItem(PresentationAction<AddItemFeature.Action>)
        case listElementTapped
        case loadList([ItemModel])
        case path(StackAction<ItemDetailFeature.State, ItemDetailFeature.Action>)
        case onDelete(IndexSet)
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let items = userDefaultsClient.loadItems()
                
                return .send(.loadList(items))
            case .refresh:
                state.isLoading = true
                let items = userDefaultsClient.loadItems()

                return .send(.loadList(items))
            case .addButtonTapped:
                state.addItem = AddItemFeature.State(item: .init(id: UUID(), name: "", date: "", firstPrice: 0, firstQuantity: 0, secondPrice: 0, secondQuantity: 0))
                return .none
            case .listElementTapped:
                return .none
            case .loadList(let items):
                state.items = items
                state.isLoading = false
                return .none
            case .addItem(.presented(.delegate(.cancel))):
                state.addItem = nil
                return .none
            case let .addItem(.presented(.delegate(.saveItem(itemModel)))):
                state.items.append(itemModel)
                return .none
            case .addItem:
                return .none
            case .path(_):
                return .none
            case let .onDelete(indexSet):
                var items = userDefaultsClient.loadItems()
                items.remove(atOffsets: indexSet)
                userDefaultsClient.saveItems(items)
                state.items = items
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
                    VStack {
                        AdmobBannerView()
                            .frame(height: 90.0)
                        List {
                            ForEach(store.items) { item in
                                NavigationLink(state: ItemDetailFeature.State(item: item)) {
                                    ItemView(item: item)
                                }
                                .buttonStyle(.borderless)
                                .listRowSeparator(.hidden)
                            }
                            .onDelete { indexSet in
                                store.send(.onDelete(indexSet))
                            }
                        }
                        .listStyle(.plain)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    store.send(.addButtonTapped)
                                }, label: {
                                    Image(systemName: "plus.circle")
                                })
                            }
                        }
                        .refreshable {
                            store.send(.refresh)
                        }
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
                    .font(.system(size: 18.0))
                Spacer()
                Text(item.averagePrice.displayFormattedStringByPrice())
                    .bold()
                    .font(.system(size: 22.0))
            }
            HStack {
                Text(item.date)
                    .foregroundStyle(.gray)
                    .font(.system(size: 14.0))
                Spacer()
                Text("\(item.profit.displayDecimalPlace(by: 2))%")
                    .bold()
                    .foregroundStyle(item.profitColor)
                    .font(.system(size: 16.0))
            }

            Divider()
        }
    }
}
