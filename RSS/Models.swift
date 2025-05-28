//
//  Models.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation

struct NewsSource: Identifiable {
    let id = UUID()
    let name: String
    let logoURL: URL?
    let emoji: String?
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageURL: URL?
    let source: NewsSource
    let pubDate: Date?
    let link: URL?  
}
