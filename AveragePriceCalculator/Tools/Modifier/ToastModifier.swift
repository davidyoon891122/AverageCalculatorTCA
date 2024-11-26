//
//  ToastModifier.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/31/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {

    @Binding var toast: ToastModel?
    @State private var workItem: DispatchWorkItem?

    var yOffset: CGFloat = -32.0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: yOffset)
                }
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { _ in
                self.showToast()
            }
    }

    @ViewBuilder
    func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(style: toast.style, message: toast.message, width: toast.width) {
                    dismissToast()
                }
            }
        }
    }

}

private extension ToastModifier {

    func dismissToast() {
        withAnimation {
            self.toast = nil
        }
    }

    func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        if toast.duration > 0 {
            workItem?.cancel()

            let task = DispatchWorkItem {
                dismissToast()
            }

            workItem = task

            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }

}
