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
        var firstQuantiy: String = ""
        var secondPrice: String = ""
        var secondQuantity: String = ""
    }

    enum Action {
        case setName(String)
        case setFirstPrice(String)
        case setFirstQuantity(String)
        case setSecondPrice(String)
        case setSecondQuantity(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setName(name):
                state.name = name
                return .none
            case let .setFirstPrice(firstPrice):
                state.firstPrice = firstPrice
                return .none
            case let .setFirstQuantity(firstQuantity):
                state.firstQuantiy = firstQuantity
                return .none
            case let .setSecondPrice(secondPrice):
                state.secondPrice = secondPrice
                return .none
            case let .setSecondQuantity(secondQuantity):
                state.secondQuantity = secondQuantity
                return .none
            }

        }
    }
}

import SwiftUI

struct AddItemView: View {

    @Perception.Bindable var store: StoreOf<AddItemFeature>

    var body: some View {
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

                    TextField("First Quantity", text: $store.firstQuantiy.sending(\.setFirstQuantity))
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
            }
        }
        .navigationTitle(store.navigationTitle)
    }

}


#Preview {
    NavigationStack {
        AddItemView(store: Store(initialState: AddItemFeature.State(item: .init(id: UUID(), name: "test", date: "2024-08-18", profitRage: 20.0, price: 3000000, quantity: 40))) {
            AddItemFeature()
        })
    }
}
