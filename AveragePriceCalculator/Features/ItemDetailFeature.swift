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

        var name: String {
            get {
                self.item.name
            }
            set {
                self.item.name = newValue
            }
        }
        var firstPrice: String {
            get {
                String(self.item.firstPrice)
            }
            set {
                self.item.firstPrice = Double(newValue) ?? 0
            }
        }
        var firstQuantity: String {
            get {
                String(self.item.firstQuantity)
            }
            set {
                self.item.firstQuantity = Double(newValue) ?? 0
            }
        }
        var secondPrice: String {
            get {
                String(self.item.secondPrice)
            }
            set {
                self.item.secondPrice = Double(newValue) ?? 0
            }
        }
        var secondQuantity: String {
            get {
                String(self.item.secondQuantity)
            }
            set {
                self.item.secondQuantity = Double(newValue) ?? 0
            }
        }
        var averagePrice: String {
            String(self.averagePriceDouble)
        }

        var totalAmount: String {
            String(self.item.firstQuantity + self.item.secondQuantity)
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

    }

    enum Action {
        case onAppear
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
        case saveButtonTapped
    }

    var body: some ReducerOf<Self> {
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
                state.firstPrice = firstPrice
                state.firstPriceDouble = Double(state.firstPrice) ?? 0

                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantity = firstQuantity
                state.firstQuantityDouble = Double(state.firstQuantity) ?? 0

                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice
                state.secondPriceDouble = Double(state.secondPrice) ?? 0

                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity
                state.secondQuantityDouble = Double(state.secondQuantity) ?? 0

                return .none
            case .saveButtonTapped:
                // saveItem(state)
                return .none
            }
        }
    }
}

import SwiftUI

struct ItemDetailView: View {

    @Perception.Bindable var store: StoreOf<ItemDetailFeature>

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
