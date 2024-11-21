//
//  ToastView.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/31/24.
//

import SwiftUI

struct ToastView: View {

    var style: ToastStyleType
    var message: String
    var duration: Double = 3.0
    var width: Double = .infinity
    var onCancelTapped: (() -> Void)

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 12.0) {
                Image(systemName: style.icon)
                    .foregroundStyle(style.themeColor)

                Text(message)
                    .font(.caption)
                    .foregroundStyle(Color("ToastForeground"))

                Spacer(minLength: 10.0)

                Button(action: {
                    onCancelTapped()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(style.themeColor)
                })
            }
            .padding()
        }
        .background(Color("ToastBackground"))
        .overlay(
            Rectangle()
                .fill(style.themeColor)
                .frame(width: 6)
                .clipped(),
            alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: width)
        .clipShape(.rect(cornerRadius: 8.0))
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }

}

#Preview {
    ToastView(style: .error, message: "Error", onCancelTapped: {
        print("did tap cancel button")
    })
}

#Preview {
    ToastView(style: .warning, message: "Warning", onCancelTapped: {
        print("did tap cancel button")
    })
}

#Preview {
    ToastView(style: .info, message: "Info", onCancelTapped: {
        print("did tap cancel button")
    })
}

#Preview {
    ToastView(style: .success, message: "Success", onCancelTapped: {
        print("did tap cancel button")
    })
}
