//
//  NewsItemView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct NewsItemView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let logoURL = newsItem.source.logoURL {
                    AsyncImage(url: logoURL) { image in
                        image.resizable()
                             .frame(width: 30, height: 30)
                             .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text(newsItem.source.name)
                    .font(.headline)
            }
            .padding([.top, .horizontal])
            
            if let imageURL = newsItem.imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(height: 200)
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
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding()
    }
}
