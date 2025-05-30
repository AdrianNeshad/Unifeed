//
//  Category.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import Foundation

enum Category: String, CaseIterable, Identifiable {
    case noje = "Nyheter"
    case sport = "Sport"
    case polisen = "Polisen"
    case finans = "Finans"
    case myndighet = "Myndigheter"
    case fotboll = "Fotboll"
    
    var iconName: String {
        switch self {
        case .noje: return "newspaper"
        case .sport: return "figure.run"
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
                // Nationella
                NewsSource(name: "Nyheter", logo: "polis_logo"),
                NewsSource(name: "Pressmeddelanden", logo: "polis_logo"),

                // Region Nord
                NewsSource(name: "Jämtland - Nyheter", logo: nil),
                NewsSource(name: "Jämtland - Händelser", logo: nil),
                NewsSource(name: "Västerbotten - Nyheter", logo: nil),
                NewsSource(name: "Västerbotten - Händelser", logo: nil),
                NewsSource(name: "Norrbotten - Nyheter", logo: nil),
                NewsSource(name: "Norrbotten - Händelser", logo: nil),
                NewsSource(name: "Västernorrland - Nyheter", logo: nil),
                NewsSource(name: "Västernorrland - Händelser", logo: nil),

                // Region Mitt
                NewsSource(name: "Gävleborg - Nyheter", logo: nil),
                NewsSource(name: "Gävleborg - Händelser", logo: nil),
                NewsSource(name: "Uppsala - Nyheter", logo: nil),
                NewsSource(name: "Uppsala - Händelser", logo: nil),
                NewsSource(name: "Västmanland - Nyheter", logo: nil),
                NewsSource(name: "Västmanland - Händelser", logo: nil),

                // Region Stockholm
                NewsSource(name: "Stockholm - Nyheter", logo: nil),
                NewsSource(name: "Stockholm - Händelser", logo: nil),
                NewsSource(name: "Gotland - Nyheter", logo: nil),
                NewsSource(name: "Gotland - Händelser", logo: nil),

                // Region Öst
                NewsSource(name: "Södermanland - Nyheter", logo: nil),
                NewsSource(name: "Södermanland - Händelser", logo: nil),
                NewsSource(name: "Östergötland - Nyheter", logo: nil),
                NewsSource(name: "Östergötland - Händelser", logo: nil),
                NewsSource(name: "Jönköping - Nyheter", logo: nil),
                NewsSource(name: "Jönköping - Händelser", logo: nil),

                // Region Väst
                NewsSource(name: "Halland - Nyheter", logo: nil),
                NewsSource(name: "Halland - Händelser", logo: nil),
                NewsSource(name: "Västra Götaland - Nyheter", logo: nil),
                NewsSource(name: "Västra Götaland - Händelser", logo: nil),

                // Region Syd
                NewsSource(name: "Skåne - Nyheter", logo: nil),
                NewsSource(name: "Skåne - Händelser", logo: nil),
                NewsSource(name: "Blekinge - Nyheter", logo: nil),
                NewsSource(name: "Blekinge - Händelser", logo: nil),
                NewsSource(name: "Kronoberg - Nyheter", logo: nil),
                NewsSource(name: "Kronoberg - Händelser", logo: nil),
                NewsSource(name: "Kalmar - Nyheter", logo: nil),
                NewsSource(name: "Kalmar - Händelser", logo: nil),

                // Region Bergslagen
                NewsSource(name: "Värmland - Nyheter", logo: nil),
                NewsSource(name: "Värmland - Händelser", logo: nil),
                NewsSource(name: "Örebro - Nyheter", logo: nil),
                NewsSource(name: "Örebro - Händelser", logo: nil),
                NewsSource(name: "Dalarna - Nyheter", logo: nil),
                NewsSource(name: "Dalarna - Händelser", logo: nil)
            ]

        case .noje:
            return [
                NewsSource(name: "Aftonbladet", logo: "aftonbladet_logo"),
                NewsSource(name: "Expressen", logo: "exp_logo"),
                NewsSource(name: "Svenska Dagbladet", logo: "svd_logo"),
                NewsSource(name: "SVT", logo: "svt_logo"),
                NewsSource(name: "TV4", logo: "tv4_logo"),
                NewsSource(name: "Dagens Industri", logo: "di_logo"),
                NewsSource(name: "Dagens Nyheter", logo: "dn_logo"),
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
                NewsSource(name: "Riksbanken", logo: "riksbanken_logo")
            ]
        case .finans:
            return [
                NewsSource(name: "Expressen Ekonomi", logo: "exp_logo")
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
            return language == "sv" ? "Nyheter" : "News"
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
