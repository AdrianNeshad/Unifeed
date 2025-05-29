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
    @AppStorage("AdsRemoved") private var AdsRemoved = false
    @StateObject private var storeManager = StoreManager()
    @StateObject var viewModel = NewsViewModel()
    @State private var showingSheet = false
    @State private var selectedLink: IdentifiableURL? = nil
    @State private var showingCategoryPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(Array(viewModel.newsItems.enumerated()), id: \.element.id) { index, item in
                        NewsItemView(newsItem: item)
                            .padding(.horizontal)
                            .onTapGesture {
                                if let link = item.link {
                                    selectedLink = IdentifiableURL(url: link)
                                }
                            }

                        // Visa NativeAd efter var 3:e nyhetskort (men bara om ads inte är bortköpta)
                        if index % 5 == 4 && !AdsRemoved {
                            NativeAdViewRepresentable()
                                .frame(height: 300)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                }
            }
            .sheet(item: $selectedLink) { wrapped in
                SafariView(url: wrapped.url)
            }
            .refreshable {
                viewModel.loadNews()
            }
            .navigationTitle(viewModel.currentCategory.localizedName(language: appLanguage))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingCategoryPicker = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                if viewModel.currentCategory == .polisen {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Location()) {
                            Image(systemName: "map")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Image(systemName: "gearshape")
                    }
                }
            }

            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showingCategoryPicker) {
                NavigationView {
                    List(Category.allCases) { category in
                        Button {
                            viewModel.currentCategory = category
                            showingCategoryPicker = false
                        } label: {
                            HStack {
                                Image(systemName: category.iconName)
                                Text(category.localizedName(language: appLanguage))
                                if viewModel.currentCategory == category {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                    .navigationTitle(appLanguage == "sv" ? "Välj kategori" : "Choose Category")
                }
            }

        }
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}


#Preview {
    Unifeed_Index()
}
