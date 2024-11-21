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
        view.addSubview(context.coordinator.bannerView)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.bannerView.adSize = adSize
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
    
    let parent: BannerView
    
    init(_ parent: BannerView) {
        self.parent = parent
    }
    
}
