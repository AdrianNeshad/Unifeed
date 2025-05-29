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
    
    func feedURL(for sourceName: String) -> URL? {
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
        case "FotbollsExpressen":
            return URL(string: "https://feeds.expressen.se/fotboll/")
        case "Expressen":
            return URL(string: "https://feeds.expressen.se/nyheter/")
        case "SportExpressen":
            return URL(string: "https://feeds.expressen.se/sport/")
        case "Svenska Dagbladet":
            return URL(string: "svd.se/feed/articles.rss")
        case "TV4":
            return URL(string: "tv4.se/rss")
        case "SVT":
            return URL(string: "svt.se/rss.xml")
        case "Krisinformation":
            return URL(string: "https://www.krisinformation.se/nyheter?rss=true")
        case "MSB":
            return URL(string: "https://www.msb.se/sv/rss-floden/rss-alla-nyheter-fran-msb/")
        case "Regeringen":
            return URL(string: "https://www.regeringen.se/Filter/RssFeed?filterType=Taxonomy&filterByType=FilterablePageBase&preFilteredCategories=1284%2C1285%2C1286%2C1287%2C1288%2C1290%2C1291%2C1292%2C1293%2C1294%2C1295%2C1296%2C1297%2C2425&rootPageReference=0&filteredContentCategories=2204%2C1334%2C2214&filteredPoliticalLevelCategories=&filteredPoliticalAreaCategories=&filteredPublisherCategories=1295%2C1296%2C1297")
        default:
            return nil
        }
    }
}
