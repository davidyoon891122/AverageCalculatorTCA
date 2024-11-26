//
//  SwiftUILottieView.swift
//  TradingApp
//
//  Created by Jiwon Yoon on 1/20/24.
//

import Foundation
import SwiftUI
import Lottie
import SnapKit

struct SwiftUILottieView: UIViewRepresentable {

    var lottieType: LottieType
    var loopMode: LottieLoopMode

    init(lottieType: LottieType, loopMode: LottieLoopMode) {
        self.lottieType = lottieType
        self.loopMode = loopMode
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)


        let animationView = LottieView(loopMode: loopMode, lottieType: lottieType)

        animationView.start()

        view.addSubview(animationView)

        animationView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}
