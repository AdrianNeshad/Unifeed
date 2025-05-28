//
//  PurchaseView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct PurchaseView: View {
    @ObservedObject var storeManager: StoreManager
    @Binding var isUnlocked: Bool
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("appLanguage") private var appLanguage = "sv"
    @AppStorage("isDarkMode") private var isDarkMode = true

    
    @available(iOS 16.0, *)
    var body: some View {
        VStack(spacing: 20) {
            Text(appLanguage == "sv" ? "Ta bort reklam permanent" : "Remove Ads Permanently")
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Text(appLanguage == "sv" ?
                 "Ta bort all reklam med ett engångsköp" :
                 "Remove all ads with a one-time purchase")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let product = storeManager.products.first {
                Button(action: { storeManager.purchaseProduct(product: product) }) {
                    Text(appLanguage == "sv" ?
                         "Köp för \(product.localizedPrice)" :
                         "Purchase for \(product.localizedPrice)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            } else {
                ProgressView(appLanguage == "sv" ? "Laddar..." : "Loading...")
            }
            
            if storeManager.transactionState == .purchased || isUnlocked {
                Text(appLanguage == "sv" ? "Tack för ditt köp! 🎉" : "Thank you for your purchase! 🎉")
                    .foregroundColor(.green)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
            
            if storeManager.transactionState == .failed {
                Text(appLanguage == "sv" ?
                    "Köpet misslyckades. Försök igen." :
                    "Purchase failed. Please try again.")
                    .foregroundColor(.red)
            }
            
            Button(appLanguage == "sv" ? "Avbryt" : "Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
