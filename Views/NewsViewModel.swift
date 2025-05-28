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
        NewsSource(name: "DN", logoURL: URL(string: "https://www.dn.se/favicon.ico")),
        NewsSource(name: "SVT", logoURL: URL(string: "https://www.svt.se/favicon.ico")),
    ]
    
    func loadNews() {
        newsItems = [] // Rensa innan ny laddning
        
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
                            pubDate: item.pubDate
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
            self.newsItems = allItems.sorted(by: { ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) })
            
            if !errors.isEmpty {
                print("Fel vid hämtning av vissa flöden: \(errors)")
            }
        }
    }
    
    private func feedURL(for sourceName: String) -> URL? {
        switch sourceName {
        case "DN":
            return URL(string: "https://www.dn.se/m/rss")
        case "SVT":
            return URL(string: "https://www.svt.se/nyheter/rss.xml")
        default:
            return nil
        }
    }
}
