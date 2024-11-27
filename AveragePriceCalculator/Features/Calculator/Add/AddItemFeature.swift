//
//  AddItemFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddItemFeature {

    @ObservableState
    struct State: Equatable {
        let navigationTitle = "Add Item View".localized()
        var item: ItemModel
        
        var name: String = ""
        var firstPrice: String = ""
        var firstQuantity: String = ""
        var secondPrice: String = ""
        var secondQuantity: String = ""
        
        var averagePrice: String {
            self.averagePriceDecimal.commaFormat
        }
        
        var totalAmount: String {
            self.totalAmountDecimal.commaFormat
        }
        
        var profit: String {
            self.profitDecimal.isNaN ? "" : String(format: "%.2f %%", NSDecimalNumber(decimal: self.profitDecimal).doubleValue)
        }

        var totalPurchasePrice: String {
            totalPurchasePriceDecimal.commaFormat
        }

//        var firstPriceDecimal: Decimal = 0
//        var firstQuantityDecimal: Decimal = 0
//        var secondPriceDecimal: Decimal = 0
//        var secondQuantityDecimal: Decimal = 0
        
        var averagePriceDecimal: Decimal {
            let totalAmount = item.firstQuantity + item.secondQuantity
            if totalAmount > 0 {
                return ((item.firstPrice * item.firstQuantity) + (item.secondPrice * item.secondQuantity)) / totalAmount
            } else {
                return 0
            }

        }
        var totalAmountDecimal: Decimal {
            item.firstQuantity + item.secondQuantity
        }
        
        var profitDecimal: Decimal {
            let firstPrice = item.firstPrice * item.firstQuantity
            let secondPrice = item.secondPrice * item.secondQuantity

            let totalPrice = firstPrice + secondPrice
            let currentPriceValue = item.secondPrice * (item.firstQuantity + item.secondQuantity)

            return ((currentPriceValue - totalPrice) / totalPrice) * 100
        }

        var totalPurchasePriceDecimal: Decimal {
            (item.firstPrice * item.firstQuantity) + (item.secondPrice * item.secondQuantity)
        }

        var isSaveButtonEnabled: Bool {
            !name.isEmpty &&
            !firstPrice.isEmpty &&
            !firstQuantity.isEmpty &&
            !secondPrice.isEmpty &&
            !secondQuantity.isEmpty
        }
        
        var focusedField: FieldType?
        
        enum FieldType: Hashable {
            
            case name
            case firstPrice
            case firstQuantity
            case secondPrice
            case secondQuantity

        }
        
        @Shared(.appStorage("theme")) var theme: ThemeType = .system
    }

    enum Action: BindableAction {
        case onAppear
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
        case saveButtonTapped
        case cancelButtonTapped
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        enum Delegate: Equatable {
            case cancel
            case saveItem(ItemModel)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.userDefaultsClient) var userDefaultsClient


    func saveItem(_ item: ItemModel) {
        var savedItems = userDefaultsClient.loadItems()
        savedItems.append(item)
        
        userDefaultsClient.saveItems(savedItems)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.focusedField = .name
                return .none
            case let .setName(name):
                state.name = name
                state.item.name = name

                return .none
            case let .setFirstPrice(firstPrice):
                state.firstPrice = firstPrice
                state.item.firstPrice = state.firstPrice.commaStringtoDouble
                
                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantity = firstQuantity
                state.item.firstQuantity = state.firstQuantity.commaStringtoDouble
                
                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice
                state.item.secondPrice = state.secondPrice.commaStringtoDouble

                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity
                state.item.secondQuantity = state.secondQuantity.commaStringtoDouble

                return .none
            case .saveButtonTapped:
                if state.firstPrice.isEmpty {
                    state.focusedField = .firstPrice
                    return .none
                } else if state.firstQuantity.isEmpty {
                    state.focusedField = .firstQuantity
                    return .none
                } else if state.secondPrice.isEmpty {
                    state.focusedField = .secondPrice
                    return .none
                } else if state.secondQuantity.isEmpty {
                    state.focusedField = .secondQuantity
                    return .none
                } else if state.name.isEmpty {
                    state.focusedField = .name
                    return .none
                }
                
                state.item.date = Date().getStringDateByFormat()
                saveItem(state.item)
                
                return .concatenate(
                    .send(.delegate(.saveItem(state.item))),
                    .send(.cancelButtonTapped)
                )
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            case .binding:
                return .none
            }
        }
    }
}

import SwiftUI

struct AddItemView: View {

    @Perception.Bindable var store: StoreOf<AddItemFeature>
    @FocusState var focusedField: AddItemFeature.State.FieldType?
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        WithPerceptionTracking {
            VStack {
                ScrollView {
                    VStack {
                        TextField("Name", text: $store.name.sending(\.setName))
                            .focused($focusedField, equals: .name)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 4.0)
                                    .stroke(.gray)
                            }
                            .padding()
                        VStack(alignment: .leading) {
                            Text("First Purchase")
                                .bold()
                                .font(.system(size: 22.0))
                            
                            TextField("First Price", text: $store.firstPrice.sending(\.setFirstPrice))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .firstPrice)
                                .padding()
                                .onChange(of: store.firstPrice) { newValue in
                                    store.send(.setFirstPrice(newValue.commaFormat))
                                    
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("First Quantity", text: $store.firstQuantity.sending(\.setFirstQuantity))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .firstQuantity)
                                .padding()
                                .onChange(of: store.firstQuantity) { newValue in
                                    store.send(.setFirstQuantity(newValue.commaFormat))
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                        }
                        .padding()
                        VStack(alignment: .leading) {
                            Text("Second Purchase")
                                .bold()
                                .font(.system(size: 22.0))
                            
                            TextField("Second Price", text: $store.secondPrice.sending(\.setSecondPrice))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .secondPrice)
                                .padding()
                                .onChange(of: store.secondPrice) { newValue in
                                    store.send(.setSecondPrice(newValue.commaFormat))
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("Second Quantity", text: $store.secondQuantity.sending(\.setSecondQuantity))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .secondQuantity)
                                .padding()
                                .onChange(of: store.secondQuantity) { newValue in
                                    store.send(.setSecondQuantity(newValue.commaFormat))
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                        }
                        .padding()
                        
                        VStack {
                            HStack {
                                Text("Total amount: ")
                                    .bold()
                                Spacer()
                                Text(store.totalAmount)
                                    .bold()

                            }
                            HStack {
                                Text("Average price: ")
                                    .bold()
                                Spacer()
                                Text(store.averagePrice)
                                    .bold()
                            }
                            HStack {
                                Text("Profit: ")
                                    .bold()
                                Spacer()
                                Text(store.profit)
                                    .bold()
                            }
                            HStack {
                                Text("Total Purchase Price: ")
                                    .bold()
                                Spacer()
                                Text(store.totalPurchasePrice)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                }
                .bind($store.focusedField, to: $focusedField)
                
                Button(action: {
                    store.send(.saveButtonTapped)
                }, label: {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(store.isSaveButtonEnabled ? .blue : .blue.opacity(0.3))
                        .foregroundStyle(store.isSaveButtonEnabled ? .white : .white.opacity(0.7))
                })
                .disabled(!store.isSaveButtonEnabled)
                .padding()
            }
            .onAppear {
                store.send(.onAppear)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        store.send(.cancelButtonTapped)
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(xmarkTintColor)
                    })
                    
                }
            }
            .navigationTitle(store.navigationTitle)
            .background(backgroundColor)
        }
    }

}

extension AddItemView {

    var backgroundColor: Color {
        switch store.theme {
        case .dark:
            return .black
        case .light:
            return .white
        case .system:
            return colorScheme == .dark ? .black : .white
        }
    }

    var xmarkTintColor: Color {
        switch store.theme {
        case .dark:
            return .white
        case .light:
            return .black
        case .system:
            return colorScheme == .dark ? .white : .black
        }
    }

}


#Preview {
    NavigationStack {
        AddItemView(store: Store(initialState: AddItemFeature.State(item: .init(id: UUID(), name: "test", date: "2024-11-22", firstPrice: 100, firstQuantity: 10, secondPrice: 90, secondQuantity: 8))) {
            AddItemFeature()
        })
    }
}
