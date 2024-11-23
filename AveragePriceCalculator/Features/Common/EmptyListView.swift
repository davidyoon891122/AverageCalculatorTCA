//
//  EmptyListView.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 11/22/24.
//

import SwiftUI

struct EmptyListView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            SwiftUILottieView(
                lottieType: .noContent,
                loopMode: .loop
            )
                .frame(width: 250.0, height: 250.0)

            Text("There are no items registered.\nPlease add an item.")
                .bold()
                .font(.system(size: 20.0))
                .multilineTextAlignment(.center)

            Spacer()
        }
    }
}

#Preview {
    EmptyListView()
}
