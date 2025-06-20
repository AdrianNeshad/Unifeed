//
//  TestContentView.swift
//  SwipeFlix
//
//  Created by Adrian Neshad on 2025-06-16.
//

import GoogleMobileAds
import SwiftUI

// [START add_view_model_to_view]
struct NativeContentView: View {
  // Single source of truth for the native ad data.
  @StateObject private var nativeViewModel = NativeAdViewModel()
  // [START_EXCLUDE silent]
  let navigationTitle: String
  // [END_EXCLUDE]
 
  var body: some View {
      VStack(spacing: 0) {
        // Updates  when the native ad data changes.
        NativeAdViewContainer(nativeViewModel: nativeViewModel)
              .frame(maxWidth: 320, maxHeight: 550)
              .cornerRadius(15)
          // minHeight determined from xib.
        // [END add_view_model_to_view]s
    }
    .onAppear {
      refreshAd()
    }
    .navigationTitle(navigationTitle)
  }

  private func refreshAd() {
    nativeViewModel.refreshAd()
  }
}

struct NativeContentView_Previews: PreviewProvider {
  static var previews: some View {
    NativeContentView(navigationTitle: "Native")
  }
}

// [START create_native_ad_view]
private struct NativeAdViewContainer: UIViewRepresentable {
  typealias UIViewType = NativeAdView

  // Observer to update the UIView when the native ad value changes.
  @ObservedObject var nativeViewModel: NativeAdViewModel

  func makeUIView(context: Context) -> NativeAdView {
    return
      Bundle.main.loadNibNamed(
        "NativeAdView",
        owner: nil,
        options: nil)?.first as! NativeAdView
  }

  func updateUIView(_ nativeAdView: NativeAdView, context: Context) {
    guard let nativeAd = nativeViewModel.nativeAd else { return }

    // Each UI property is configurable using your native ad.
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

    // For the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    // Associate the native ad view with the native ad object. This is required to make the ad
    // clickable.
    // Note: this should always be done after populating the ad views.
    nativeAdView.nativeAd = nativeAd
  }
  // [END create_native_ad_view]

  private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
}
