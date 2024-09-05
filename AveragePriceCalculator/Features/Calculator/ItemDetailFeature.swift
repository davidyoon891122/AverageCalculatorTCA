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

        var toast: ToastModel?
        
        var focusedField: FieldType? {
            didSet {
                print(self.focusedField)
            }
        }
        
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
    
    func modify(state: State) {
        let userDefaults = UserDefaultsManager()
        var savedData = userDefaults.loadItems()
        
        guard let index = savedData.firstIndex(where: { $0.id == state.item.id }) else { return }
        
        savedData[index] = state.item
        
        userDefaults.saveItems(items: savedData)
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
                state.toast = ToastModel(style: .success, message: "Success Modify")
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
                                .focused($focusedField, equals: .firstPrice)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("First Quantity", text: $store.firstQuantity.sending(\.setFirstQuantity))
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
                            
                            TextField("Second Price", text: $store.secondPrice.sending(\.setSecondPrice))
                                .focused($focusedField, equals: .secondPrice)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4.0)
                                        .stroke(.gray)
                                }
                            
                            TextField("Second Quantity", text: $store.secondQuantity.sending(\.setSecondQuantity))
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
                    store.send(.modifyButtonTapped)
                }, label: {
                    Text("Modify")
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(store.isSaveButtonEnabled ? .gray : .gray.opacity(0.7))
                        .foregroundStyle(store.isSaveButtonEnabled ? .white : .white.opacity(0.7))
                })
                .disabled(!store.isSaveButtonEnabled)
                .padding()
            }
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
