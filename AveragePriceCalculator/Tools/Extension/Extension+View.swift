//
//  Extension+View.swift
//  AveragePriceCalculator
//
//  Created by Jiwon Yoon on 8/31/24.
//

import SwiftUI

extension View {
    
    func taostView(toast: Binding<ToastModel?>, yOffset: CGFloat = -32.0) -> some View {
        self.modifier(ToastModifier(toast: toast, yOffset: yOffset))
    }

}
