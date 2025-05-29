//
//  NativeAd.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-29.
//

import SwiftUI
import GoogleMobileAds

struct NativeAdViewRepresentable: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GADNativeAdView {
        // Ladda XIB som är kopplad till CustomNativeAdView
        guard let adView = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)?.first as? CustomNativeAdView else {
            fatalError("Kunde inte ladda NativeAdView.xib")
        }

        // Hitta rootViewController på rätt sätt (iOS 15+)
        let rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController

        // Skapa och konfigurera AdLoader
        let adLoader = GADAdLoader(
            adUnitID: "ca-app-pub-3940256099942544/3986624511", // ← Byt till ditt eget ID vid release
            rootViewController: rootViewController,
            adTypes: [.native],
            options: nil
        )

        context.coordinator.adView = adView
        adLoader.delegate = context.coordinator
        adLoader.load(GADRequest())

        return adView
    }

    func updateUIView(_ uiView: GADNativeAdView, context: Context) {
        // Behöver inte uppdateras
    }

    class Coordinator: NSObject, GADNativeAdLoaderDelegate {
        var adView: GADNativeAdView?

        func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
            guard let adView = adView as? CustomNativeAdView else { return }

            (adView.headlineLabel)?.text = nativeAd.headline
            (adView.bodyLabel)?.text = nativeAd.body
            (adView.callToActionButton)?.setTitle(nativeAd.callToAction, for: .normal)

            if let icon = nativeAd.icon?.image {
                adView.iconImageView.image = icon
                adView.iconImageView.isHidden = false
            } else {
                adView.iconImageView.isHidden = true
            }

            adView.nativeAd = nativeAd
            adView.headlineLabel.isHidden = false
            adView.bodyLabel.isHidden = false
            adView.callToActionButton.isHidden = false
        }

        func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
            print("❌ Misslyckades att ladda native ad: \(error.localizedDescription)")
        }
    }
}
