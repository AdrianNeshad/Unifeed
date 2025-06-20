//
//  NewsViewModel.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import Foundation
 import Combine
 import SwiftUI
 
 class NewsViewModel: ObservableObject {
     @Published var isLoading: Bool = false
     @Published var newsItems: [NewsItem] = []
 
     @Published var currentCategory: Category = .noje
     @Published var currentCustomCategory: CustomCategory? = nil
 
     @Published var activeSources: Set<String> = [] {
         didSet { saveActiveSources() }
     }
 
     @Published var customSources: [Category: [NewsSource]] = [:] {
         didSet { saveCustomSources() }
     }
 
     @Published var customCategorySources: [UUID: [NewsSource]] = [:] {
         didSet { saveCustomCategorySources() }
     }
 
     @Published var customCategories: [CustomCategory] = [] {
         didSet { saveCustomCategories() }
     }
 
     private var categoryKey: String {
         if let custom = currentCustomCategory {
             return "activeSources_custom_\(custom.id.uuidString)"
         } else {
             return "activeSources_\(currentCategory.rawValue)"
         }
     }
 
     var filteredSources: [NewsSource] {
         if let custom = currentCustomCategory {
             let customList = customCategorySources[custom.id] ?? []
             return customList.filter { activeSources.isEmpty || activeSources.contains($0.name) }
         } else {
             let standard = currentCategory.sources
             let custom = customSources[currentCategory] ?? []
             let all = standard + custom
           return all.filter { activeSources.isEmpty || activeSources.contains($0.name) }
       }
   }

   init() {
       loadCustomSources()
       loadCustomCategories()
       loadCustomCategorySources()
       loadActiveSources()
       loadNews()
   }

   func setCategory(_ category: Category) {
       currentCategory = category
       currentCustomCategory = nil
       loadActiveSources()
       loadNews()
   }

   func setCustomCategory(_ category: CustomCategory) {
       currentCustomCategory = category
       currentCategory = .noje
       loadActiveSources()
       loadNews()
   }

   func addCustomCategory(name: String, icon: String) {
       let new = CustomCategory(name: name, icon: icon)
       customCategories.append(new)
       customCategorySources[new.id] = []
       activeSources = []
       setCustomCategory(new)
   }

   func removeCustomCategory(_ category: CustomCategory) {
       customCategories.removeAll { $0.id == category.id }
       customCategorySources[category.id] = nil
       UserDefaults.standard.removeObject(forKey: "activeSources_custom_\(category.id.uuidString)")
       if currentCustomCategory?.id == category.id {
           currentCustomCategory = nil
       }
       loadNews()
   }

   func saveCustomSources() {
       let encoder = JSONEncoder()
       if let data = try? encoder.encode(customSources) {
           UserDefaults.standard.set(data, forKey: "customSources")
       }
   }

   func loadCustomSources() {
       if let data = UserDefaults.standard.data(forKey: "customSources") {
           let decoder = JSONDecoder()
           if let decoded = try? decoder.decode([Category: [NewsSource]].self, from: data) {
               customSources = decoded
           }
       }
   }

   func saveCustomCategories() {
       if let data = try? JSONEncoder().encode(customCategories) {
           UserDefaults.standard.set(data, forKey: "customCategories")
       }
   }

   func loadCustomCategories() {
       if let data = UserDefaults.standard.data(forKey: "customCategories"),
          let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
           customCategories = decoded
       }
   }

   func saveCustomCategorySources() {
       if let data = try? JSONEncoder().encode(customCategorySources) {
           UserDefaults.standard.set(data, forKey: "customCategorySources")
       }
   }

   func loadCustomCategorySources() {
       if let data = UserDefaults.standard.data(forKey: "customCategorySources"),
          let decoded = try? JSONDecoder().decode([UUID: [NewsSource]].self, from: data) {
           customCategorySources = decoded
       }
   }

   func saveActiveSources() {
       let joined = activeSources.joined(separator: "|")
       UserDefaults.standard.setValue(joined, forKey: categoryKey)
   }

   func loadActiveSources() {
       let saved = UserDefaults.standard.string(forKey: categoryKey)?.split(separator: "|").map(String.init) ?? []

       let allNames: [String] = {
           if let custom = currentCustomCategory {
               return (customCategorySources[custom.id] ?? []).map { $0.name }
           } else {
               return (currentCategory.sources + (customSources[currentCategory] ?? [])).map { $0.name }
           }
       }()

       guard !allNames.isEmpty else {
           activeSources = []
           return
       }

       let validSaved = saved.filter { allNames.contains($0) }
       if !validSaved.isEmpty {
           activeSources = Set(validSaved)
       } else {
           activeSources = Set(allNames)
       }
   }

   func loadNews() {
       isLoading = true
       newsItems = []

       if filteredSources.isEmpty {
           isLoading = false
           newsItems = []
           return
       }

       let group = DispatchGroup()
       var allItems: [NewsItem] = []
       var errors: [Error] = []

       let sources = filteredSources

       for source in sources {
           let url = source.url ?? feedURL(for: source.name)
           guard let feedURL = url else { continue }

           let rssFetcher = RSSFetcher()
           group.enter()
           rssFetcher.fetchFeed(from: feedURL, source: source) { result in
               switch result {
               case .success(let items):
                   allItems.append(contentsOf: items)
               case .failure(let error):
                   errors.append(error)
               }
               group.leave()
           }
       }

       group.notify(queue: .main) {
           var seen = Set<String>()
           let uniqueItems = allItems.filter { item in
               let key = "\(item.title)-\(item.pubDate?.timeIntervalSince1970 ?? 0)"
               if seen.contains(key) {
                   return false
               } else {
                   seen.insert(key)
                   return true
               }
           }
           self.newsItems = uniqueItems.sorted(by: { ($0.pubDate ?? Date.distantPast) > ($1.pubDate ?? Date.distantPast) })
           self.isLoading = false

           if !errors.isEmpty {
               print("Fel vid hämntning: \(errors)")
           }
       }
   }
    
    func feedURL(for sourceName: String) -> URL? {
        switch sourceName {
        case "Pressmeddelanden":
            return URL(string: "https://polisen.se/aktuellt/rss/hela-landet/pressmeddelanden-hela-landet/")
        case "Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/hela-landet/nyheter-hela-landet/")
            //Region Nord
        case "Jämtland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/jamtland/nyheter-rss---jamtland/")
        case "Jämtland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/jamtland/handelser-rss---jamtland/")
        case "Västerbotten - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/vasterbotten/nyheter-rss---vasterbotten/")
        case "Västerbotten - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/vasterbotten/handelser-rss---vasterbotten/")
        case "Norrbotten - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/norrbotten/nyheter-rss---norrbotten/")
        case "Norrbotten - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/norrbotten/handelser-rss---norrbotten/")
        case "Västernorrland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/vasternorrland/nyheter-rss---vasternorrland/")
        case "Västernorrland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/vasternorrland/handelser-rss---vasternorrland/")
            
        // Region Mitt
        case "Gävleborg - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/gavleborg/nyheter-rss---gavleborg/")
        case "Gävleborg - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/gavleborg/handelser-rss---gavleborg/")
        case "Uppsala - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/uppsala-lan/nyheter-rss---uppsala-lan/")
        case "Uppsala - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/uppsala-lan/handelser-rss---uppsala-lan/")
        case "Västmanland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/vastmanland/nyheter-rss---vastmanland/")
        case "Västmanland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/vastmanland/handelser-rss---vastmanland/")
            
        // Region Stockholm
        case "Stockholm - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/stockholms-lan/nyheter-rss---stockholms-lan/")
        case "Stockholm - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/stockholms-lan/handelser-rss---stockholms-lan/")
        case "Gotland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/gotland/nyheter-rss---gotland/")
        case "Gotland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/gotland/handelser-rss---gotland/")

            // Region Öst
        case "Södermanland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/sodermanland/nyheter-rss---sodermanland/")
        case "Södermanland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/sodermanland/handelser-rss---sodermanland/")
        case "Östergötland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/ostergotland/nyheter-rss---ostergotland/")
        case "Östergötland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/ostergotland/handelser-rss---ostergotland/")
        case "Jönköping - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/jonkopings-lan/nyheter-rss---jonkopings-lan/")
        case "Jönköping - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/jonkopings-lan/handelser-rss---jonkopings-lan/")

            // Region Väst
        case "Halland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/halland/nyheter-rss---halland/")
        case "Halland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/halland/handelser-rss---halland/")
        case "Västra Götaland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/vastra-gotaland/nyheter-rss---vastra-gotaland/")
        case "Västra Götaland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/vastra-gotaland/handelser-rss---vastra-gotaland/")

            // Region Syd
        case "Skåne - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/skane/nyheter-rss---skane/")
        case "Skåne - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/skane/handelser-rss---skane/")
        case "Blekinge - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/blekinge/nyheter-rss---blekinge/")
        case "Blekinge - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/blekinge/handelser-rss---blekinge/")
        case "Kronoberg - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/kronoberg/nyheter-rss---kronoberg/")
        case "Kronoberg - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/kronoberg/handelser-rss---kronoberg/")
        case "Kalmar - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/kalmar-lan/nyheter-rss---kalmar-lan/")
        case "Kalmar - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/kalmar-lan/handelser-rss---kalmar-lan/")

            // Region Bergslagen
        case "Värmland - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/varmland/nyheter-rss---varmland/")
        case "Värmland - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/varmland/handelser-rss---varmland/")
        case "Örebro - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/orebro-lan/nyheter-rss---orebro-lan/")
        case "Örebro - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/orebro-lan/handelser-rss---orebro-lan/")
        case "Dalarna - Nyheter":
            return URL(string: "https://polisen.se/aktuellt/rss/dalarna/nyheter-rss---dalarna/")
        case "Dalarna - Händelser":
            return URL(string: "https://polisen.se/aktuellt/rss/dalarna/handelser-rss---dalarna/")
            
        case "Folkhälsomyndigheten":
            return URL(string: "https://www.folkhalsomyndigheten.se/nyheter-och-press/nyhetsarkiv/?syndication=rss")
        case "Aftonbladet":
            return URL(string: "https://rss.aftonbladet.se/rss2/small/pages/sections/senastenytt/")
        case "Dagens Industri":
            return URL(string: "https://www.di.se/digital/rss")
        case "Fotbollskanalen":
            return URL(string: "https://www.fotbollskanalen.se/rss/")
        case "FotbollsExpressen":
            return URL(string: "https://feeds.expressen.se/fotboll/")
        case "Expressen":
            return URL(string: "https://feeds.expressen.se/nyheter/")
        case "SportExpressen":
            return URL(string: "https://feeds.expressen.se/sport/")
        case "Expressen Ekonomi":
            return URL(string: "https://feeds.expressen.se/ekonomi/")
        case "Svenska Dagbladet":
            return URL(string: "https://www.svd.se/feed/articles.rss")
        case "SVT":
            return URL(string: "https://www.svt.se/nyheter/rss.xml")
        case "TV4":
            return URL(string: "https://www.tv4.se/rss")
        case "Krisinformation":
            return URL(string: "https://www.krisinformation.se/nyheter?rss=true")
        case "MSB":
            return URL(string: "https://www.msb.se/sv/rss-floden/rss-alla-nyheter-fran-msb/")
        case "Regeringen":
            return URL(string: "https://www.regeringen.se/Filter/RssFeed?filterType=Taxonomy&filterByType=FilterablePageBase&preFilteredCategories=1284%2C1285%2C1286%2C1287%2C1288%2C1290%2C1291%2C1292%2C1293%2C1294%2C1295%2C1296%2C1297%2C2425&rootPageReference=0&filteredContentCategories=1334&filteredPoliticalLevelCategories=&filteredPoliticalAreaCategories=&filteredPublisherCategories=1296")
        case "Skatteverket":
            return URL(string: "https://skatteverket.se/4.dfe345a107ebcc9baf800017652/12.dfe345a107ebcc9baf800017658.portlet?state=rss&sv.contenttype=text/xml;charset=UTF-8")
        case "Livsmedelsverket":
            return URL(string: "https://www.livsmedelsverket.se/rss/rss-pressmeddelanden")
        case "Läkemedelsverket":
            return URL(string: "https://www.lakemedelsverket.se/api/newslist/newsrss?query=&pageTypeId=1&from=&to=")
        case "Riksbanken":
            return URL(string: "https://www.riksbank.se/sv/rss/nyheter/")
        case "Dagens Nyheter":
            return URL(string: "https://www.dn.se/rss/")
        case "MarketWatch":
            return URL(string: "https://feeds.content.dowjones.io/public/rss/mw_topstories")
        case "Yahoo Sports":
            return URL(string: "https://sports.yahoo.com/general/news/rss/")
        case "Fotbolltransfers":
            return URL(string: "https://fotbolltransfers.com/rss/nyheter/alla")
        case "SVT Sport":
            return URL(string: "https://www.svt.se/sport/rss.xml")
            
        default:
            return nil
        }
    }
}
