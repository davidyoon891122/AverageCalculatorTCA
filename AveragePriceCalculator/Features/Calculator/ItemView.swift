//
//  ItemView.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 11/25/24.
//

import SwiftUI

struct ItemView: View {

    let item: ItemModel

    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                    .bold()
                    .font(.system(size: 18.0))
                Spacer()
                Text(item.averagePrice)
                    .bold()
                    .font(.system(size: 22.0))
            }
            HStack {
                Text(item.date)
                    .foregroundStyle(.gray)
                    .font(.system(size: 14.0))
                Spacer()
                Text("\(item.profit) %")
                    .bold()
                    .foregroundStyle(item.profitColor)
                    .font(.system(size: 16.0))
            }

            HStack {
                Text("Total Purchase Price")
                    .bold()
                    .font(.system(size: 16.0))
                Spacer()
                Text(item.totalPurchasePrice)
                    .bold()
                    .font(.system(size: 16.0))
            }
            .padding(.vertical, 4)

            Divider()
        }
    }

}

#Preview {
    ItemView(item: .preview)
}
