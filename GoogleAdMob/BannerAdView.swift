//
//  BannerAdView.swift
//  SwipeFlix
//
//  Created by Adrian Neshad on 2025-06-15.
//

import SwiftUI
import GoogleMobileAds
import UIKit

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = adUnitID

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return bannerView }
        
        bannerView.rootViewController = root
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        uiView.load(Request())
    }
}
