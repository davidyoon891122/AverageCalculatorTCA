//
//  AdmobBannerView.swift
//  AveragePriceCalculator
//
//  Created by Davidyoon on 11/21/24.
//

import SwiftUI
import GoogleMobileAds

struct AdmobBannerView: View {
    var body: some View {
        GeometryReader { geometry in
            let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(geometry.size.width)
            
            VStack {
                Spacer()
                BannerView(adSize: adSize)
                    .frame(height: adSize.size.height)
            }
            
        }
    }
}

#Preview {
    AdmobBannerView()
}
