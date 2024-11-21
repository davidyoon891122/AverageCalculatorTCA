//
//  BannerView.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: UIViewRepresentable {
    
    let adSize: GADAdSize
    
    init(adSize: GADAdSize) {
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        [
            context.coordinator.bannerView,
            context.coordinator.loadingView
        ].forEach { view.addSubview($0) }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.bannerView.adSize = adSize
        
        context.coordinator.loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }
    
}

class BannerCoordinator: NSObject, GADBannerViewDelegate {
    
    private(set) lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(adSize: parent.adSize)
        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        banner.load(GADRequest())
        banner.delegate = self
        return banner
    }()
    
    private(set) lazy var loadingView: LottieView = {
        let lottieView = LottieView()
        
        return lottieView
    }()
    
    let parent: BannerView
    
    init(_ parent: BannerView) {
        self.parent = parent
        super.init()
        self.loadingView.start()
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.loadingView.alpha = 1
        self.bannerView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.loadingView.alpha = 0
            self.bannerView.alpha = 1
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: any Error) {
        self.loadingView.alpha = 0
        self.bannerView.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.loadingView.alpha = 1
        }
    }
    
}

