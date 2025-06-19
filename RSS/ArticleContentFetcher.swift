//
//  ArticleContentFetcher.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import Foundation
import SwiftSoup

class ArticleContentFetcher {

    /// Hämtar och extraherar brödtexten från en given URL.
    /// Inkluderar förbättrad hantering av radbrytningar.
    /// - Parameters:
    ///   - url: URL:en till artikeln.
    ///   - completion: En closure som anropas med resultatet (String eller Error).
    func fetchFullArticle(from url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "ArticleContentFetcher", code: 0, userInfo: [NSLocalizedDescriptionKey: "Kunde inte få HTML-data från URL."])))
                return
            }

            do {
                let doc: Document = try SwiftSoup.parse(html)
                var articleText = ""

                let selectors = [
                    "article",
                    "div.article-body",
                    "div.content-main",
                    "div.story-body",
                    "div#article-content",
                    "div.body-text",
                    "div.text-body",
                    "main article",
                ]

                // Försök att hitta det primära innehållselementet
                var mainContentElement: Element?

                for selector in selectors {
                    if let element = try? doc.select(selector).first() {
                        mainContentElement = element
                        break
                    }
                }

                if let contentElement = mainContentElement {
                    // Vi har hittat ett huvudelement. Nu går vi igenom dess barn.
                    // Detta är mer robust för att bevara stycken och radbrytningar.
                    let nodes = contentElement.getChildNodes()
                    for node in nodes {
                        if let element = node as? Element {
                            let tag = element.tagName().lowercased()

                            // Lägg till radbrytningar före och efter vissa block-element
                            if ["p", "div", "h1", "h2", "h3", "h4", "h5", "h6", "li"].contains(tag) {
                                // Lägg till två radbrytningar för nya stycken
                                if !articleText.isEmpty && !articleText.hasSuffix("\n\n") {
                                    articleText += "\n\n"
                                }
                                articleText += try element.text()
                            } else if tag == "br" {
                                // Explicit radbrytning
                                articleText += "\n"
                            } else {
                                // För andra element, lägg bara till texten
                                articleText += try element.text()
                            }
                        } else if let textNode = node as? TextNode {
                            // Hantera ren text som inte är insvept i ett element
                            let text = textNode.text().trimmingCharacters(in: .whitespacesAndNewlines)
                            if !text.isEmpty {
                                articleText += text
                            }
                        }
                    }
                } else {
                    // Fallback: Om inget specifikt innehållselement hittades,
                    // försök samla ihop alla paragrafer direkt i body.
                    let paragraphs = try doc.select("p")
                    articleText = try paragraphs.array().map { try $0.text() }.joined(separator: "\n\n")
                }

                // Sista fallback om ingen text hittades alls eller var för kort
                if articleText.isEmpty || articleText.count < 50 { // Mindre än 50 tecken, troligen fel
                     if let bodyText = try doc.body()?.text() {
                         articleText = bodyText
                     }
                 }


                // Använd befintliga HTML-dekodare och trimma slutliga mellanslag/radbrytningar
                completion(.success(articleText.decodedHTML.trimmingCharacters(in: .whitespacesAndNewlines)))

            } catch Exception.Error(_, let message) {
                completion(.failure(NSError(domain: "ArticleContentFetcher", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fel vid HTML-parsning: \(message)"])))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
