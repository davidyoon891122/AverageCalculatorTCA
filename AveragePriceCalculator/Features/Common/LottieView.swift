//
//  LottieView.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import UIKit
import Lottie
import SnapKit

enum LottieType {
    case admob
    
    var imageName: String {
        switch self {
        case .admob:
            "admob-loading"
        }
    }
}

final class LottieView: UIView {
    
    private lazy var lottieAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView()
        lottieAnimationView.loopMode = self.loopMode
        lottieAnimationView.animation = .named(self.lottieType.imageName)
        
        return lottieAnimationView
    }()
    
    private let loopMode: LottieLoopMode
    private let lottieType: LottieType
    
    init(loopMode: LottieLoopMode = .loop, lottieType: LottieType = .admob) {
        self.loopMode = loopMode
        self.lottieType = lottieType
        super.init(frame: .zero)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        self.lottieAnimationView.play()
    }
    
    func stop() {
        self.lottieAnimationView.stop()
    }
    
}

private extension LottieView {
    
    func setupViews() {
        self.addSubview(self.lottieAnimationView)
        
        self.lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    LottieView()
}
