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
    
    private let rssFetcher = RSSFetcher()
    
    private let sources: [NewsSource] = [
        NewsSource(name: "Polisen", logoURL: nil, emoji: "👮🏼‍♂️"),
        NewsSource(name: "Folkhälsomyndigheten", logoURL: URL(string: "https://www.folkhalsomyndigheten.se/favicon.ico"), emoji: nil),
    ]
    
    func loadNews() {
        newsItems = []
        let group = DispatchGroup()
        var allItems: [NewsItem] = []
        var errors: [Error] = []
        
        for source in sources {
            guard let feedURL = feedURL(for: source.name) else { continue }
            
            group.enter()
            rssFetcher.fetchFeed(from: feedURL) { result in
                switch result {
                case .success(let items):
                    let itemsWithSource = items.map { item in
                        NewsItem(
                            title: item.title,
                            description: item.description,
                            imageURL: item.imageURL,
                            source: source,
                            pubDate: item.pubDate,
                            link: item.link
                        )
                    }
                    allItems.append(contentsOf: itemsWithSource)
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
        default:
            return nil
        }
    }
    
    init(mock: Bool = false) {
            if mock {
                newsItems = [
                    NewsItem(
                        title: "Exempelnyhet 1",
                        description: "Det här är en exempelbeskrivning.",
                        imageURL: nil,
                        source: NewsSource(name: "Mockkälla", logoURL: nil, emoji: nil),
                        pubDate: Date(),
                        link: URL(string: "https://exempel.se/nyhet1")
                    ),
                    NewsItem(
                        title: "Exempelnyhet 2",
                        description: "Andra exemplet på nyhetstext.",
                        imageURL: nil,
                        source: NewsSource(name: "Mockkälla 2", logoURL: nil, emoji: nil),
                        pubDate: Date().addingTimeInterval(-3600),
                        link: URL(string: "https://exempel.se/nyhet2")
                    )
                ]
            }
        }
}
