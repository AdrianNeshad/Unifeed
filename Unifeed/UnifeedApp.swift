//
//  UnifeedApp.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import GoogleMobileAds

@main
struct UnifeedApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    init() {
            MobileAds.shared.start()
        }
    
    var body: some Scene {
        WindowGroup {
            Unifeed_Index()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
