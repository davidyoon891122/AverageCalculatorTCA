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
        let navigationTitle = "Add Item View"
        var item: ItemModel
        var name: String = ""
        var firstPrice: String = ""
        var firstQuantity: String = ""
        var secondPrice: String = ""
        var secondQuantity: String = ""
        var totalAmount: String {
            String(totalAmountDouble)
        }
        var averagePrice: String {
            String(self.averagePriceDouble)
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
    }

    enum Action {
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
        case saveButtonTapped
        case cancelButtonTapped
        case delegate(Delegate)
        enum Delegate: Equatable {
            case cancel
            case saveItem(ItemModel)
        }
    }
    
    @Dependency(\.dismiss) var dismiss


    func saveItem(_ item: ItemModel) {
        let userDefaultsManager = UserDefaultsManager()
        var savedItems = userDefaultsManager.loadItems()
        savedItems.append(item)
        
        userDefaultsManager.saveItems(items: savedItems)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setName(name):
                state.name = name
                state.item.name = name

                return .none
            case let .setFirstPrice(firstPrice):
                state.firstPrice = firstPrice
                state.firstPriceDouble = Double(state.firstPrice) ?? 0
                state.item.firstPrice = Double(state.firstPrice) ?? 0
                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantity = firstQuantity
                state.firstQuantityDouble = Double(state.firstQuantity) ?? 0
                state.item.firstQuantity = Double(state.firstQuantity) ?? 0
                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice
                state.secondPriceDouble = Double(state.secondPrice) ?? 0
                state.item.secondPrice = Double(state.secondPrice) ?? 0

                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity
                state.secondQuantityDouble = Double(state.secondQuantity) ?? 0
                state.item.secondQuantity = Double(state.secondQuantity) ?? 0

                return .none
            case .saveButtonTapped:
                state.item.date = Date().getStringDateByFormat()
                return .run { [item = state.item] send in
                    saveItem(item)
                    await send(.delegate(.saveItem(item)))
                    await self.dismiss()
                }
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}

import SwiftUI

struct AddItemView: View {

    @Perception.Bindable var store: StoreOf<AddItemFeature>

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack {
                    TextField("Name", text: $store.name.sending(\.setName))
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
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 4.0)
                                    .stroke(.gray)
                            }

                        TextField("First Quantity", text: $store.firstQuantity.sending(\.setFirstQuantity))
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

                        TextField("Second Price", text: $store.secondPrice.sending(\.setSecondPrice))
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 4.0)
                                    .stroke(.gray)
                            }

                        TextField("Second Quantity", text: $store.secondQuantity.sending(\.setSecondQuantity))
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
            }
            .navigationTitle(store.navigationTitle)
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
