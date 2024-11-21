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
        var name: String {
            get {
                self.item.name
            }
            set {
                self.item.name = newValue
            }
        }
        var firstPrice: String = ""
        var firstQuantity: String = ""
        var secondPrice: String = ""
        var secondQuantity: String = ""
        
        var averagePrice: String {
            self.averagePriceDouble.commaFormat
        }
        
        var totalAmount: String {
            self.totalAmountDouble.commaFormat
        }
        
        var profit: String {
            self.profitDouble.isNaN ? "" : "\(self.profitDouble.displayDecimalPlace(by: 2)) %"
        }

        var firstPriceDouble: Double = 0
        var firstQuantityDouble: Double = 0
        var secondPriceDouble: Double = 0
        var secondQuantityDouble: Double = 0
        var averagePriceDouble: Double {
            let totalAmount = firstQuantityDouble + secondQuantityDouble
            if totalAmount > 0 {
                 return ((firstPriceDouble * firstQuantityDouble) + (secondPriceDouble * secondQuantityDouble)) / totalAmount
            } else {
                return 0
            }

        }
        var totalAmountDouble: Double {
            firstQuantityDouble + secondQuantityDouble
        }
        var profitDouble: Double {
            let firstPrice = firstPriceDouble * firstQuantityDouble // 1
            let secondPrice = secondPriceDouble * secondQuantityDouble // 20

            let totalPrice = firstPrice + secondPrice
            let currentPriceValue = secondPriceDouble * (firstQuantityDouble + secondQuantityDouble)

            return ((currentPriceValue - totalPrice) / totalPrice) * 100
        }

        var isSaveButtonEnabled: Bool {
            !name.isEmpty &&
            !firstPrice.isEmpty &&
            !firstQuantity.isEmpty &&
            !secondPrice.isEmpty &&
            !secondQuantity.isEmpty &&
            firstPriceDouble > 0 &&
            firstQuantityDouble > 0 &&
            secondPriceDouble > 0 &&
            secondQuantityDouble > 0
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
                state.firstPrice = firstPrice.commaFormat
                state.firstPriceDouble = state.firstPrice.commaStringtoDouble
                state.item.firstPrice = state.firstPrice.commaStringtoDouble
                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantity = firstQuantity.commaFormat
                state.firstQuantityDouble = state.firstQuantity.commaStringtoDouble
                state.item.firstQuantity = state.firstQuantity.commaStringtoDouble
                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice.commaFormat
                state.secondPriceDouble = state.secondPrice.commaStringtoDouble
                state.item.secondPrice = state.secondPrice.commaStringtoDouble

                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity.commaFormat
                state.secondQuantityDouble = state.secondQuantity.commaStringtoDouble
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
                            
                            TextField("First Price", text: Binding(
                                get: { store.firstPrice },
                                set: { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    store.send(.setFirstPrice(filtered))
                                }
                            ))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .firstPrice)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("First Quantity", text: Binding(
                                get: { store.firstQuantity },
                                set: { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    store.send(.setFirstQuantity(filtered))
                                }
                            ))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .firstQuantity)
                                .padding()
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
                            
                            TextField("Second Price", text: Binding(
                                get: { store.secondPrice },
                                set: { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    store.send(.setSecondPrice(filtered))
                                }
                            ))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .secondPrice)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("Second Quantity", text: Binding(
                                get: { store.secondQuantity },
                                set: { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    store.send(.setSecondQuantity(filtered))
                                }
                            ))
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .secondQuantity)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                        }
                        .padding()
                        
                        VStack {
                            HStack {
                                Text("total amount: ")
                                Spacer()
                                Text(store.totalAmount)
                                
                            }
                            HStack {
                                Text("average price: ")
                                Spacer()
                                Text(store.averagePrice)
                            }
                            HStack {
                                Text("profit: ")
                                Spacer()
                                Text(store.profit)
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
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(store.isSaveButtonEnabled ? .gray : .gray.opacity(0.7))
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
                            .tint(store.theme == .dark ? .white : .black)
                    })
                    
                }
            }
            .navigationTitle(store.navigationTitle)
            .background(store.theme == .dark ? .black : .white)
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
