//
//  TestRSSFetcher.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation
import FeedKit

/*
func testFeedParser() {
    guard let url = URL(string: "https://feeds.bbci.co.uk/news/rss.xml") else { return }
    let parser = FeedParser(URL: url)
    parser.parseAsync { result in
        switch result {
        case .success(let feed):
            print("Parsed feed successfully: \(feed)")
        case .failure(let error):
            print("Parsing failed: \(error)")
        }
    }
}
 */
/*
import Foundation
import FeedKit

class RSSFetcher {
    func fetchFeed(from url: URL, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .success(let feed):
                var newsItems: [NewsItem] = []
                
                if let rssFeed = feed.rssFeed {
                    for item in rssFeed.items ?? [] {
                        let title = item.title ?? "Ingen titel"
                        let description = item.description ?? ""
                        
                        var imageURL: URL? = nil
                        if let media = item.media?.mediaContents?.first, let urlString = media.attributes?.url {
                            imageURL = URL(string: urlString)
                        } else if let enclosure = item.enclosure, let urlString = enclosure.url {
                            imageURL = URL(string: urlString)
                        }
                        
                        let pubDate = item.pubDate
                        let source = NewsSource(name: "Dummy", logoURL: nil)
                        
                        let newsItem = NewsItem(title: title, description: description, imageURL: imageURL, source: source, pubDate: pubDate)
                        newsItems.append(newsItem)
                    }
                }
                
                completion(.success(newsItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

*/
