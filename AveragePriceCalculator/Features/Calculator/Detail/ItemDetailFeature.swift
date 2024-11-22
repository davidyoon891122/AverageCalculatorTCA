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
            
            self.firstPriceDouble = item.firstPrice
            self.firstQuantityDouble = item.firstQuantity
            self.secondPriceDouble = item.secondPrice
            self.secondQuantityDouble = item.secondQuantity
        }

        var name: String = ""
        var firstPrice: String = ""
        var firstQuantity: String = ""
        var secondPrice: String = ""
        var secondQuantity: String = ""
        
        var averagePrice: String {
            self.averagePriceDouble.commaFormat
        }

        var totalAmount: String {
            (self.item.firstQuantity + self.item.secondQuantity).commaFormat
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
        case onAppear
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
        case modifyButtonTapped
        case setToast(ToastModel?)
        case binding(BindingAction<State>)
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
            case .onAppear:
                state.firstPriceDouble = state.item.firstPrice
                state.firstQuantityDouble = state.item.firstQuantity
                state.secondPriceDouble = state.item.secondPrice
                state.secondQuantityDouble = state.item.secondQuantity

                return .none
            case let .setName(name):
                state.name = name

                return .none
            case let .setFirstPrice(firstPrice):
                print(firstPrice)
                state.firstPrice = firstPrice
                state.firstPriceDouble = state.firstPrice.commaStringtoDouble
                state.item.firstPrice = state.firstPrice.commaStringtoDouble

                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantity = firstQuantity
                state.firstQuantityDouble = state.firstQuantity.commaStringtoDouble
                state.item.firstQuantity = state.firstQuantity.commaStringtoDouble

                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice
                state.secondPriceDouble = state.secondPrice.commaStringtoDouble
                state.item.secondPrice = state.secondPrice.commaStringtoDouble

                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity
                state.secondQuantityDouble = state.secondQuantity.commaStringtoDouble
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
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    store.send(.setFirstPrice(filtered.commaFormat))
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
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    store.send(.setFirstQuantity(filtered.commaFormat))
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
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    store.send(.setSecondPrice(filtered.commaFormat))
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
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    store.send(.setSecondQuantity(filtered.commaFormat))
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                        }
                        .padding()
                        
                        VStack {
                            HStack {
                                Text("total amount: ")
                                    .bold()
                                Spacer()
                                Text(store.totalAmount)
                                    .bold()
                                
                            }
                            HStack {
                                Text("average price: ")
                                    .bold()
                                Spacer()
                                Text(store.averagePrice)
                                    .bold()
                            }
                            HStack {
                                Text("profit: ")
                                    .bold()
                                Spacer()
                                Text(store.profit)
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
            .onAppear {
                store.send(.onAppear)
            }
            .navigationTitle(store.navigationTitle)
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
