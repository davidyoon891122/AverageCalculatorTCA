//
//  ItemDetailFeature.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/24/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ItemDetailFeature {

    @ObservableState
    struct State: Equatable {
        var item: ItemModel
        var navigationTitle: String {
            self.item.name
        }
        
        init(item: ItemModel) {
            self.item = item
            self.name = item.name
            self.firstPrice = item.firstPrice.commaFormat
            self.firstQuantity = item.firstQuantity.commaFormat
            self.secondPrice = item.secondPrice.commaFormat
            self.secondQuantity = item.secondQuantity.commaFormat
        }

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

        var averagePriceDecimal: Decimal {
            let totalAmount = item.firstQuantity + item.secondQuantity
            if totalAmount > 0 {
                let result = ((item.firstPrice * item.firstQuantity) + (item.secondPrice * item.secondQuantity)) / totalAmount
                return result
            } else {
                return 0
            }

        }

        var profitDecimal: Decimal {
            let firstPrice = item.firstPrice * item.firstQuantity
            let secondPrice = item.secondPrice * item.secondQuantity

            let totalPrice = firstPrice + secondPrice
            let currentPriceValue = item.secondPrice * (item.firstQuantity + item.secondQuantity)

            return ((currentPriceValue - totalPrice) / totalPrice) * 100
        }
        
        var totalAmountDecimal: Decimal {
            item.firstQuantity + item.secondQuantity
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

        var toast: ToastModel?
        
        var focusedField: FieldType?
                
        enum FieldType: Hashable {
            
            case name
            case firstPrice
            case firstQuantity
            case secondPrice
            case secondQuantity

        }

    }

    enum Action: BindableAction {
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
        case modifyButtonTapped
        case setToast(ToastModel?)
        case binding(BindingAction<State>)
        case didTapAddingButton
    }
    
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    
    func modify(state: State) {
        var savedData = userDefaultsClient.loadItems()
        
        guard let index = savedData.firstIndex(where: { $0.id == state.item.id }) else { return }
        
        savedData[index] = state.item
        
        userDefaultsClient.saveItems(savedData)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .setName(name):
                state.name = name

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
            case .modifyButtonTapped:
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
                
                modify(state: state)
                state.toast = ToastModel(style: .success, message: "Successfully Modify".localized())
                return .none
            case let .setToast(toast):
                state.toast = toast
                return .none
            case .binding:
                return .none
            case .didTapAddingButton:
                state.firstPrice = state.averagePrice
                state.item.firstPrice = state.averagePrice.commaStringtoDouble
                state.firstQuantity = state.totalAmount
                state.item.firstQuantity = state.totalAmount.commaStringtoDouble

                state.secondPrice = ""
                state.item.secondPrice = 0
                state.secondQuantity = ""
                state.item.secondQuantity = 0

                return .none
            }
        }
    }
}

import SwiftUI

struct ItemDetailView: View {

    @Perception.Bindable var store: StoreOf<ItemDetailFeature>
    @FocusState var focusedField: ItemDetailFeature.State.FieldType?

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
                    store.send(.modifyButtonTapped)
                }, label: {
                    Text("Modify")
                        .frame(maxWidth: .infinity, minHeight: 50.0)
                        .background(store.isSaveButtonEnabled ? .gray : .gray.opacity(0.7))
                        .foregroundStyle(store.isSaveButtonEnabled ? .white : .white.opacity(0.7))
                })
                .disabled(!store.isSaveButtonEnabled)
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .taostView(toast: $store.toast.sending(\.setToast))
            .navigationTitle(store.navigationTitle)
            .toolbar {
                Button(action: {
                    store.send(.didTapAddingButton)
                }, label: {
                    Text("Additional purchase")
                })
            }
        }
    }

}

#Preview {
    NavigationStack {
        ItemDetailView(store: Store(initialState: ItemDetailFeature.State(item: .preview)) {
            ItemDetailFeature()
        })
    }
}
