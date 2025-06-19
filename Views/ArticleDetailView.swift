//
//  ArticleDetailView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import SwiftUI

struct ArticleDetailView: View {
    let newsItem: NewsItem
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("appLanguage") private var appLanguage = "sv"
    @Environment(\.dismiss) var dismiss
    @State private var fullArticleText: String = ""
    @State private var isLoadingFullArticle: Bool = true
    @State private var showError: Bool = false
    @State private var selectedLink: IdentifiableURL? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if let imageURL = newsItem.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }

                    Text(newsItem.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        if let logo = newsItem.source.logo {
                            if UIImage(systemName: logo) != nil {
                                Image(systemName: logo)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.accentColor)
                            } else {
                                Image(logo)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .clipShape(Circle())
                            }
                        }
                        Text(newsItem.source.name)
                            .font(.subheadline)
                        if let date = newsItem.pubDate {
                            Text("— \(dateFormatted(date))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    if isLoadingFullArticle {
                        ProgressView(appLanguage == "sv" ? "Laddar full artikel..." : "Loading full article...")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if showError {
                        Text(appLanguage == "sv" ? "Kunde inte ladda hela artikelns innehåll. Visar sammanfattning." : "Could not load full article content. Showing summary.")
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                        Text(newsItem.description)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    else {
                        Text(fullArticleText.isEmpty ? newsItem.description : fullArticleText)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    if let link = newsItem.link {
                        Button {
                            self.selectedLink = IdentifiableURL(url: link)
                        } label: {
                            Text(appLanguage == "sv" ? "Originalartikel" : "Original Article")
                                .font(.callout)
                                .padding(8)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding(.vertical)
            }
            .sheet(item: $selectedLink) { wrapped in
                SafariView(url: wrapped.url)
            }
            .navigationTitle(newsItem.source.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(appLanguage == "sv" ? "Klar" : "Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let url = newsItem.link {
                    ArticleContentFetcher().fetchFullArticle(from: url) { result in
                        DispatchQueue.main.async {
                            self.isLoadingFullArticle = false
                            switch result {
                            case .success(let text):
                                if text.isEmpty {
                                    self.showError = true
                                } else {
                                    self.fullArticleText = text
                                }
                            case .failure(let error):
                                print("Fel vid hämtning av full artikel: \(error.localizedDescription)")
                                self.showError = true
                            }
                        }
                    }
                } else {
                    self.isLoadingFullArticle = false
                    self.showError = true
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: appLanguage == "sv" ? "sv_SE" : "en_US")
        return formatter.string(from: date)
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
