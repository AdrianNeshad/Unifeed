//
//  Models.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation

struct NewsSource: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let logo: String?
    let url: URL?
    let isCustom: Bool

    init(name: String, logo: String?, url: URL?, isCustom: Bool = false) {
        self.id = UUID()
        self.name = name
        self.logo = logo
        self.url = url
        self.isCustom = isCustom
    }
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageURL: URL?
    let source: NewsSource
    let pubDate: Date?
    let link: URL?
    var fullArticleContent: String?
}
