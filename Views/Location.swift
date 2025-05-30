//
//  Location.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct Location: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: NewsViewModel
    @AppStorage("appLanguage") private var appLanguage = "sv"
    
    @State private var expandedRegions: Set<String> = []

    var body: some View {
        List {
            // Sektion för nationella flöden
            Section(header: Text(appLanguage == "sv" ? "Nationella flöden" : "National Feeds")) {
                ForEach(nationellaKällor) { source in
                    sourceRow(source)
                }
            }

            Section(header: Text(appLanguage == "sv" ? "Lokala områden" : "Local Areas")) {
                ForEach(regionKarta.keys.sorted(), id: \.self) { region in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedRegions.contains(region) },
                            set: { expanded in
                                if expanded {
                                    expandedRegions.insert(region)
                                } else {
                                    expandedRegions.remove(region)
                                }
                            }
                        ),
                        content: {
                            ForEach(regionKarta[region]!) { source in
                                sourceRow(source)
                            }
                        },
                        label: {
                            Text(region)
                                .font(.headline)
                        }
                    )
                }
            }

        }
        .navigationTitle(appLanguage == "sv" ? "Välj lokalområde" : "Choose Local Area")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(appLanguage == "sv" ? "Klar" : "Done") {
                    viewModel.loadNews()
                    dismiss()
                }
            }
        }
    }

    private func sourceRow(_ source: NewsSource) -> some View {
        Button {
            toggle(source)
        } label: {
            HStack {
                if let logo = source.logo {
                    Image(logo)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(Circle())
                }
                Text(source.name)
                    .padding(.leading, source.logo != nil ? 4 : 0)
                    .foregroundColor(.primary)
                Spacer()

                Image(systemName: viewModel.activeSources.contains(source.name) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.accentColor)
            }
        }
    }

    private func toggle(_ source: NewsSource) {
        if viewModel.activeSources.contains(source.name) {
            viewModel.activeSources.remove(source.name)
        } else {
            viewModel.activeSources.insert(source.name)
        }
    }

    private var nationellaKällor: [NewsSource] {
        viewModel.currentCategory.sources.prefix(2).map { $0 }
    }

    private var regionKarta: [String: [NewsSource]] {
        let alla = viewModel.currentCategory.sources.dropFirst(2)

        // Exempel på regionsindelning – måste matcha namn
        let regioner = [
            "Region Nord": ["Jämtland", "Västerbotten", "Norrbotten", "Västernorrland"],
            "Region Mitt": ["Gävleborg", "Uppsala", "Västmanland"],
            "Region Stockholm": ["Stockholm", "Gotland"],
            "Region Öst": ["Södermanland", "Östergötland", "Jönköping"],
            "Region Väst": ["Halland", "Västra Götaland"],
            "Region Syd": ["Skåne", "Blekinge", "Kronoberg", "Kalmar"],
            "Region Bergslagen": ["Värmland", "Örebro", "Dalarna"]
        ]

        var result: [String: [NewsSource]] = [:]

        for (region, län) in regioner {
            let sources = alla.filter { source in
                län.contains { source.name.hasPrefix($0) }
            }
            if !sources.isEmpty {
                result[region] = sources
            }
        }

        return result
    }
}
