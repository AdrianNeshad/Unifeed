//
//  Unifeed Index.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct Unifeed_Index: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("appLanguage") private var appLanguage = "sv"
    @AppStorage("adsRemoved") private var adsRemoved = false
    @StateObject private var storeManager = StoreManager()
    @StateObject var viewModel = NewsViewModel()
    @State private var showingSheet = false
    @State private var selectedLink: URL? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) { 
                    ForEach(viewModel.newsItems) { item in
                        NewsItemView(newsItem: item)
                            .padding(.horizontal)
                            .onTapGesture {
                                if let link = item.link {
                                    selectedLink = link
                                    showingSheet = true
                                    }
                            }
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                if let url = selectedLink {
                    SafariView(url: url)
                } else {
                    Text("Ingen länk tillgänglig")
                        .padding()
                }
            }
            .refreshable {
                viewModel.loadNews()
            }
            .navigationTitle(appLanguage == "sv" ? "Nyheter" : "News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Category()) {
                        Image(systemName: "square.grid.2x2")
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Location()) {
                        Image(systemName: "map")
                        }
                    }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Image(systemName: "gearshape")
                        }
                    }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .onAppear {
                viewModel.loadNews()
            }
        }
    }
}

#Preview {
    Unifeed_Index()
}
