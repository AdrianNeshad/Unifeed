//
//  RSSFetcher.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation

class RSSFetcher: NSObject, XMLParserDelegate {
    private var items: [NewsItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentPubDateString = ""
    private var currentImageURLString: String?
    private var currentLinkString = ""
    private var completionHandler: ((Result<[NewsItem], Error>) -> Void)?
    private var currentSource: NewsSource?

    func fetchFeed(from url: URL, source: NewsSource, completion: @escaping (Result<[NewsItem], Error>) -> Void) {
        self.currentSource = source
        self.completionHandler = completion
        self.items = []

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            if !parser.parse() {
                completion(.failure(NSError(domain: "Parsing failed", code: 0)))
            }
        }
        task.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDateString = ""
            currentImageURLString = nil
            currentLinkString = ""
        }
        if (elementName == "enclosure" || elementName == "media:content"), let url = attributeDict["url"] {
            currentImageURLString = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDateString += string
        case "link":
            currentLinkString += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            // Om ingen enclosure-bild hittades, försök extrahera från HTML
            if currentImageURLString == nil {
                if let imgURL = extractFirstImageURL(from: currentDescription) {
                    currentImageURLString = imgURL
                }
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            let pubDate = dateFormatter.date(from: currentPubDateString.trimmingCharacters(in: .whitespacesAndNewlines))

            let imageURL = currentImageURLString != nil ? URL(string: currentImageURLString!) : nil
            let linkURL = URL(string: currentLinkString.trimmingCharacters(in: .whitespacesAndNewlines))

            let newsItem = NewsItem(
                title: currentTitle.trimmingCharacters(in: .whitespacesAndNewlines).decodedHTML,
                description: currentDescription.trimmingCharacters(in: .whitespacesAndNewlines).decodedHTML,
                imageURL: imageURL,
                source: currentSource!,
                pubDate: pubDate,
                link: linkURL
            )
            items.append(newsItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?(.success(items))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        completionHandler?(.failure(parseError))
    }

    private func extractFirstImageURL(from htmlString: String) -> String? {
        guard let imgTagRange = htmlString.range(of: "<img[^>]*src=[\"']([^\"']+)[\"'][^>]*>", options: .regularExpression) else {
            return nil
        }

        let imgTag = htmlString[imgTagRange]

        let pattern = "src=[\"']([^\"']+)[\"']"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: String(imgTag), range: NSRange(imgTag.startIndex..., in: imgTag)),
           let range = Range(match.range(at: 1), in: imgTag) {
            
            var urlString = String(imgTag[range])
            if urlString.hasPrefix("//") {
                urlString = "https:" + urlString
            } else if urlString.hasPrefix("/") {
                if let sourceName = currentSource?.name {
                    switch sourceName {
                    case "Svenska Dagbladet":
                        urlString = "https://www.svd.se" + urlString
                    case "SVT":
                        urlString = "https://www.svt.se" + urlString
                    default:
                        break
                    }
                }
            }
            return urlString
        }

        return nil
    }

}
