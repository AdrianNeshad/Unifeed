//
//  Category.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import Foundation

enum Category: String, CaseIterable, Identifiable {
    case noje = "Nöje"
    case myndighet = "Myndigheter"
    case finans = "Finans"
    case polisen = "Polisen"
    case sport = "Sport"

    var id: String { self.rawValue }

    var sources: [NewsSource] {
        switch self {
        case .polisen:
            return [NewsSource(name: "Polisen", logo: "polis_logo")]
        case .noje:
            return [NewsSource(name: "Aftonbladet", logo: "aftonbladet_logo")]
        case .myndighet:
            return [NewsSource(name: "Folkhälsomyndigheten", logo: "fhm_logo")]
        case .finans:
            return [NewsSource(name: "Dagens Industri", logo: "di_logo")]
        case .sport:
            return [NewsSource(name: "Fotbollskanalen", logo: "fk_logo")]
        }
    }  
    
    func localizedName(language: String) -> String {
        switch self {
        case .noje:
            return language == "sv" ? "Nöje" : "Entertainment"
        case .myndighet:
            return language == "sv" ? "Myndigheter" : "Authorities"
        case .finans:
            return language == "sv" ? "Finans" : "Finance"
        case .polisen:
            return language == "sv" ? "Polisen" : "Police"
        case .sport:
            return language == "sv" ? "Sport" : "Sport"
        }
    }
}
