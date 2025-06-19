//
//  Unifeed Index.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI
import AlertToast

struct Unifeed_Index: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("appLanguage") private var appLanguage = "sv"
    @AppStorage("AdsRemoved") private var AdsRemoved = false
    @StateObject private var storeManager = StoreManager()
    @StateObject var viewModel = NewsViewModel()
    @State private var selectedNewsItem: NewsItem? = nil
    @State private var showingCategoryPicker = false
    @State private var showFeedUpdatedToast = false
    @State private var wasLoading = false
    @State private var showingFilterSheet = false
    @State private var showingAddCategory = false

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    if viewModel.isLoading {
                        VStack(spacing: 8) {
                            ProgressView()
                                .padding(.top, 20)
                                .scaleEffect(1.75)
                            Text(appLanguage == "sv" ? "Laddar flöde..." : "Loading Feed...")
                                .font(.body)
                                .padding(.top, 20)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } else {
                        ForEach(Array(viewModel.newsItems.enumerated()), id: \.element.id) { _, item in
                            NewsItemView(newsItem: item)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selectedNewsItem = item
                                }
                        }
                    }
                }
            }
            .sheet(item: $selectedNewsItem) { item in
                ArticleDetailView(newsItem: item)
            }
            .refreshable {
                viewModel.loadNews()
            }
            .navigationTitle(viewModel.currentCustomCategory?.name ?? viewModel.currentCategory.localizedName(language: appLanguage))
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
                        NavigationLink(destination: Location().environmentObject(viewModel)) {
                            Image(systemName: "map")
                        }
                    }
                }
                if viewModel.currentCategory != .polisen && viewModel.currentCustomCategory == nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingFilterSheet = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                if viewModel.currentCustomCategory != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingFilterSheet = true
                        } label: {
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
            .onChange(of: viewModel.isLoading) { isLoading in
                if wasLoading && !isLoading {
                    showFeedUpdatedToast = true
                }
                wasLoading = isLoading
            }
            .toast(isPresenting: $showFeedUpdatedToast, duration: 1.5) {
                AlertToast(displayMode: .hud,
                           type: .complete(.green),
                           title: appLanguage == "sv" ? "Uppdaterat" : "Updated",
                           subTitle: appLanguage == "sv" ? "Visar senaste" : "Showing Latest")
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .sheet(isPresented: $showingFilterSheet) {
                NavigationView {
                    Filter()
                        .environmentObject(viewModel)
                }
            }
                .sheet(isPresented: $showingCategoryPicker) {
                    NavigationView {
                        List {
                            Section(header: Text(appLanguage == "sv" ? "Standardflöden" : "Default Feeds")) {
                                ForEach(Category.allCases) { category in
                                    categoryRow(category)
                                }
                            }
                            Section(header: Text(appLanguage == "sv" ? "Eget flöde" : "Custom Feed")) {
                                ForEach(viewModel.customCategories) { custom in
                                    Button {
                                        viewModel.setCustomCategory(custom)
                                        showingCategoryPicker = false
                                    } label: {
                                        HStack {
                                            Image(systemName: custom.icon)
                                            Text(custom.name)
                                                .foregroundColor(.primary)
                                            if viewModel.currentCustomCategory?.id == custom.id {
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            viewModel.removeCustomCategory(custom)
                                        } label: {
                                            Label("Radera", systemImage: "trash")
                                        }
                                    }
                                }
                                Button {
                                    showingAddCategory = true
                                } label: {
                                    Label(appLanguage == "sv" ? "Lägg till flöde" : "Add new feed", systemImage: "plus")
                                }
                            }
                        }
                        .navigationTitle(appLanguage == "sv" ? "Välj kategori" : "Choose Category")
                        .sheet(isPresented: $showingAddCategory) {
                                    NavigationView {
                                        AddCustomCategoryView()
                                            .environmentObject(viewModel)
                                    }
                                }
                            }
                        }
        }
    }

    private func categoryRow(_ category: Category) -> some View {
        Button {
            viewModel.setCategory(category)
            showingCategoryPicker = false
        } label: {
            HStack {
                Image(systemName: category.iconName)
                Text(category.localizedName(language: appLanguage))
                    .foregroundColor(.primary)
                if viewModel.currentCategory == category && viewModel.currentCustomCategory == nil {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

#Preview {
    Unifeed_Index()
}
