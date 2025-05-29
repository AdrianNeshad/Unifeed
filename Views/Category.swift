//
//  Category.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import Foundation

enum Category: String, CaseIterable, Identifiable {
    case noje = "Nöjesnyheter"
    case sport = "Sport"
    case polisen = "Polisen"
    case finans = "Finans"
    case myndighet = "Myndigheter"
    case fotboll = "Fotboll"
    
    var iconName: String {
        switch self {
        case .noje: return "newspaper"
        case .sport: return "sportscourt"
        case .polisen: return "shield.lefthalf.fill"
        case .finans: return "dollarsign.circle"
        case .myndighet: return "building.columns"
        case .fotboll: return "soccerball"
        }
    }
    
    var id: String { self.rawValue }

    var sources: [NewsSource] {
        switch self {
        case .polisen:
            return [
                NewsSource(name: "Polisen", logo: "polis_logo")
            ]
        case .noje:
            return [
                NewsSource(name: "Aftonbladet", logo: "aftonbladet_logo"),
                NewsSource(name: "Expressen", logo: "exp_logo"),
                NewsSource(name: "Svenska Dagbladet", logo: "svd_logo"),
                NewsSource(name: "SVT", logo: "svt_logo"),
                NewsSource(name: "TV4", logo: "tv4_logo"),
            ]
        case .myndighet:
            return [
                NewsSource(name: "Folkhälsomyndigheten", logo: "fhm_logo"),
                NewsSource(name: "Krisinformation", logo: "ki_logo"),
                NewsSource(name: "MSB", logo: "msb_logo"),
                NewsSource(name: "Regeringen", logo: "regeringen_logo"),
                NewsSource(name: "Skatteverket", logo: "skatteverket_logo"),
                NewsSource(name: "Livsmedelsverket", logo: "livsmedelsverket_logo"),
                NewsSource(name: "Läkemedelsverket", logo: "läkemedelsverket_logo"),
            ]
        case .finans:
            return [
                NewsSource(name: "Dagens Industri", logo: "di_logo")
            ]
        case .sport:
            return [
                NewsSource(name: "SportExpressen", logo: "exp_logo")
            ]
        case .fotboll:
            return [
                NewsSource(name: "Fotbollskanalen", logo: "fk_logo"),
                NewsSource(name: "FotbollsExpressen", logo: "exp_logo")
            ]
        }
    }  
    
    func localizedName(language: String) -> String {
        switch self {
        case .noje:
            return language == "sv" ? "Nöjesnyheter" : "News"
        case .myndighet:
            return language == "sv" ? "Myndigheter" : "Authorities"
        case .finans:
            return language == "sv" ? "Finans" : "Finance"
        case .polisen:
            return language == "sv" ? "Polisen" : "Police"
        case .sport:
            return language == "sv" ? "Sport" : "Sport"
        case .fotboll:
            return language == "sv" ? "Fotboll" : "Football"
        }
    }
}
