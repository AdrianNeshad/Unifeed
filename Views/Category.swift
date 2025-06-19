//
//  Category.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import Foundation

enum Category: String, CaseIterable, Identifiable, Codable {
    case noje = "Nyheter"
    case polisen = "Polisen"
    case myndighet = "Myndigheter"
    case sport = "Sport"
    case finans = "Ekonomi"
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
                NewsSource(name: "Nyheter", logo: "polis_logo", url: nil),
                NewsSource(name: "Pressmeddelanden", logo: "polis_logo", url: nil),

                // Region Nord
                NewsSource(name: "Jämtland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Jämtland - Händelser", logo: nil, url: nil),
                NewsSource(name: "Västerbotten - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Västerbotten - Händelser", logo: nil, url: nil),
                NewsSource(name: "Norrbotten - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Norrbotten - Händelser", logo: nil, url: nil),
                NewsSource(name: "Västernorrland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Västernorrland - Händelser", logo: nil, url: nil),
                // Region Mitt
                NewsSource(name: "Gävleborg - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Gävleborg - Händelser", logo: nil, url: nil),
                NewsSource(name: "Uppsala - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Uppsala - Händelser", logo: nil, url: nil),
                NewsSource(name: "Västmanland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Västmanland - Händelser", logo: nil, url: nil),
                // Region Stockholm
                NewsSource(name: "Stockholm - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Stockholm - Händelser", logo: nil, url: nil),
                NewsSource(name: "Gotland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Gotland - Händelser", logo: nil, url: nil),
                // Region Öst
                NewsSource(name: "Södermanland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Södermanland - Händelser", logo: nil, url: nil),
                NewsSource(name: "Östergötland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Östergötland - Händelser", logo: nil, url: nil),
                NewsSource(name: "Jönköping - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Jönköping - Händelser", logo: nil, url: nil),
                // Region Väst
                NewsSource(name: "Halland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Halland - Händelser", logo: nil, url: nil),
                NewsSource(name: "Västra Götaland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Västra Götaland - Händelser", logo: nil, url: nil),
                // Region Syd
                NewsSource(name: "Skåne - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Skåne - Händelser", logo: nil, url: nil),
                NewsSource(name: "Blekinge - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Blekinge - Händelser", logo: nil, url: nil),
                NewsSource(name: "Kronoberg - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Kronoberg - Händelser", logo: nil, url: nil),
                NewsSource(name: "Kalmar - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Kalmar - Händelser", logo: nil, url: nil),
                // Region Bergslagen
                NewsSource(name: "Värmland - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Värmland - Händelser", logo: nil, url: nil),
                NewsSource(name: "Örebro - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Örebro - Händelser", logo: nil, url: nil),
                NewsSource(name: "Dalarna - Nyheter", logo: nil, url: nil),
                NewsSource(name: "Dalarna - Händelser", logo: nil, url: nil),
            ]

        case .noje:
            return [
                NewsSource(name: "Aftonbladet", logo: "aftonbladet_logo", url: nil),
                NewsSource(name: "Expressen", logo: "exp_logo", url: nil),
                NewsSource(name: "Svenska Dagbladet", logo: "svd_logo", url: nil),
                NewsSource(name: "SVT", logo: "svt_logo", url: nil),
                NewsSource(name: "TV4", logo: "tv4_logo", url: nil),
                NewsSource(name: "Dagens Industri", logo: "di_logo", url: nil),
                NewsSource(name: "Dagens Nyheter", logo: "dn_logo", url: nil),
            ]
        case .myndighet:
            return [
                NewsSource(name: "Folkhälsomyndigheten", logo: "fhm_logo", url: nil),
                NewsSource(name: "Krisinformation", logo: "ki_logo", url: nil),
                NewsSource(name: "MSB", logo: "msb_logo", url: nil),
                NewsSource(name: "Regeringen", logo: "regeringen_logo", url: nil),
                NewsSource(name: "Skatteverket", logo: "skatteverket_logo", url: nil),
                NewsSource(name: "Livsmedelsverket", logo: "livsmedelsverket_logo", url: nil),
                NewsSource(name: "Läkemedelsverket", logo: "läkemedelsverket_logo", url: nil),
                NewsSource(name: "Riksbanken", logo: "riksbanken_logo", url: nil),
            ]
        case .finans:
            return [
                NewsSource(name: "Expressen Ekonomi", logo: "exp_logo", url: nil),
                NewsSource(name: "MarketWatch", logo: "mw_logo", url: nil),
            ]
        case .sport:
            return [
                NewsSource(name: "SportExpressen", logo: "exp_logo", url: nil),
                NewsSource(name: "Yahoo Sports", logo: "yh_logo", url: nil),
                NewsSource(name: "SVT Sport", logo: "svt_logo", url: nil),
            ]
        case .fotboll:
            return [
                NewsSource(name: "Fotbollskanalen", logo: "fk_logo", url: nil),
                NewsSource(name: "FotbollsExpressen", logo: "exp_logo", url: nil),
                NewsSource(name: "Fotbolltransfers", logo: "ft_logo", url: nil),
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
            return language == "sv" ? "Ekonomi" : "Economics"
        case .polisen:
            return language == "sv" ? "Polisen" : "Police"
        case .sport:
            return language == "sv" ? "Sport" : "Sport"
        case .fotboll:
            return language == "sv" ? "Fotboll" : "Football"
        }
    }
}
