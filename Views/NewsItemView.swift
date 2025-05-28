//
//  NewsItemView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct NewsItemView: View {
    let newsItem: NewsItem
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let emoji = newsItem.source.emoji {
                    Text(emoji)
                        .font(.system(size: 20)) 
                        .frame(width: 30, height: 30)
                } else if let logoURL = newsItem.source.logoURL {
                    AsyncImage(url: logoURL) { image in
                        image.resizable()
                             .frame(width: 30, height: 30)
                             .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 30, height: 30)
                    }
                } else {
                    // Fallback ifall varken emoji eller logoURL finns
                    Image(systemName: "photo")
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                
                Text(newsItem.source.name)
                    .font(.headline)
            }
            .padding([.top, .horizontal])
            
            if let imageURL = newsItem.imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(height: 100)
                         .clipped()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 200)
                }
            }
            
            Text(newsItem.title)
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
            Text(newsItem.description)
                .font(.body)
                .padding([.horizontal, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isDarkMode ? Color.gray.opacity(0.15) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isDarkMode ? Color.gray.opacity(0.5) : Color.black, lineWidth: 1)
                )
        )
        .padding(.top, 20)
    }
}
