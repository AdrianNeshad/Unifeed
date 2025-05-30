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
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
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
                            }
                        }
                    }
                    .refreshable {
                        isLoading = true
                        viewModel.loadNews {
                            isLoading = false
                        }
                    }
                }
            }
            .sheet(item: $selectedLink) { wrapped in
                SafariView(url: wrapped.url)
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
                if viewModel.currentCategory != .polisen {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Filter().environmentObject(viewModel)) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings().environmentObject(viewModel)) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showingCategoryPicker) {
                NavigationView {
                    List(Category.allCases) { category in
                        Button {
                            isLoading = true
                            viewModel.currentCategory = category
                            // laddningen triggas automatiskt via didSet
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
        .onAppear {
            isLoading = true
            viewModel.loadNews {
                isLoading = false
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
