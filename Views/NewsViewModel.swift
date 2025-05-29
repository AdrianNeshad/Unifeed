//
//  NewsViewModel.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []

    @Published var currentCategory: Category = .myndighet {
        didSet {
            loadNews()
        }
    }

    init() {
        loadNews()
    }

    func loadNews() {
        newsItems = []
        let group = DispatchGroup()
        var allItems: [NewsItem] = []
        var errors: [Error] = []

        let sources = currentCategory.sources

        for source in sources {
            guard let feedURL = feedURL(for: source.name) else { continue }

            let rssFetcher = RSSFetcher()
            group.enter()
            rssFetcher.fetchFeed(from: feedURL, source: source) { result in
                switch result {
                case .success(let items):
                    allItems.append(contentsOf: items)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            var seen = Set<String>()
            let uniqueItems = allItems.filter { item in
                let key = "\(item.title)-\(item.pubDate?.timeIntervalSince1970 ?? 0)"
                if seen.contains(key) {
                    return false
                } else {
                    seen.insert(key)
                    return true
                }
            }
            self.newsItems = uniqueItems.sorted(by: { ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) })

            if !errors.isEmpty {
                print("Fel vid hämtning: \(errors)")
            }
        }
    }

    private func feedURL(for sourceName: String) -> URL? {
        switch sourceName {
        case "Polisen":
            return URL(string: "https://polisen.se/aktuellt/rss/hela-landet/handelser-i-hela-landet/")
        case "Folkhälsomyndigheten":
            return URL(string: "https://www.folkhalsomyndigheten.se/nyheter-och-press/nyhetsarkiv/?syndication=rss")
        case "Aftonbladet":
            return URL(string: "https://rss.aftonbladet.se/rss2/small/pages/sections/senastenytt/")
        case "Dagens Industri":
            return URL(string: "https://www.dn.se/rss/")
        case "Fotbollskanalen":
            return URL(string: "https://www.fotbollskanalen.se/rss/")
        default:
            return nil
        }
    }
}
