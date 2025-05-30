//
//  Location.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct Location: View {
    @State private var selectedFeeds: Set<String> = [
        "https://polisen.se/aktuellt/rss/hela-landet/press-rss---nationella/",
        "https://polisen.se/aktuellt/rss/hela-landet/pressmeddelanden-hela-landet/",
        "https://polisen.se/aktuellt/rss/hela-landet/nyheter-rss---nationella/"
    ]

    @State private var expandedRegions: Set<String> = []

    var body: some View {
        List {
            Section(header: Text("Nationella flöden")) {
                ForEach(nationalFeeds) { feed in
                    Button(action: {
                        toggle(feed.url)
                    }) {
                        HStack {
                            Text(feed.title)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: selectedFeeds.contains(feed.url) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }

            Section(header: Text("Lokala flöden")) {
                ForEach(localFeeds.keys.sorted(), id: \.self) { region in
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
                        )
                    ) {
                        ForEach(localFeeds[region] ?? []) { feed in
                            Button(action: {
                                toggle(feed.url)
                            }) {
                                HStack {
                                    Text(feed.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: selectedFeeds.contains(feed.url) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    } label: {
                        Text(region)
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("Välj flöden")
    }

    private func toggle(_ url: String) {
        if selectedFeeds.contains(url) {
            selectedFeeds.remove(url)
        } else {
            selectedFeeds.insert(url)
        }
    }
}


let nationalFeeds = [
    PoliceFeed(title: "Press – Nationella", url: "https://polisen.se/aktuellt/rss/hela-landet/press-rss---nationella/"),
    PoliceFeed(title: "Pressmeddelanden – Hela landet", url: "https://polisen.se/aktuellt/rss/hela-landet/pressmeddelanden-hela-landet/"),
    PoliceFeed(title: "Nyheter – Nationella", url: "https://polisen.se/aktuellt/rss/hela-landet/nyheter-rss---nationella/")
]

let localFeeds: [String: [PoliceFeed]] = [
    "Region Nord": [
        PoliceFeed(title: "Jämtland", url: "https://polisen.se/rss/jamtlands-lan"),
        PoliceFeed(title: "Västerbotten", url: "https://polisen.se/rss/vasterbottens-lan"),
        PoliceFeed(title: "Norrbotten", url: "https://polisen.se/rss/norrbottens-lan"),
        PoliceFeed(title: "Västernorrland", url: "https://polisen.se/rss/vasternorrlands-lan"),
    ],
    "Region Mitt": [
        PoliceFeed(title: "Gävleborg", url: "https://polisen.se/rss/gavleborgs-lan"),
        PoliceFeed(title: "Uppsala", url: "https://polisen.se/rss/uppsala-lan"),
        PoliceFeed(title: "Västmanland", url: "https://polisen.se/rss/vastmanlands-lan"),
    ],
    "Region Stockholm": [
        PoliceFeed(title: "Stockholm", url: "https://polisen.se/rss/stockholms-lan"),
        PoliceFeed(title: "Gotland", url: "https://polisen.se/rss/gotlands-lan"),
    ],
    "Region Öst": [
        PoliceFeed(title: "Södermanland", url: "https://polisen.se/rss/sodermanlands-lan"),
        PoliceFeed(title: "Östergötland", url: "https://polisen.se/rss/ostergotlands-lan"),
        PoliceFeed(title: "Jönköping", url: "https://polisen.se/rss/jonkopings-lan"),
    ],
    "Region Väst": [
        PoliceFeed(title: "Halland", url: "https://polisen.se/rss/hallands-lan"),
        PoliceFeed(title: "Västra Götaland", url: "https://polisen.se/rss/vastra-gotalands-lan"),
    ],
    "Region Syd": [
        PoliceFeed(title: "Skåne", url: "https://polisen.se/rss/skane-lan"),
        PoliceFeed(title: "Blekinge", url: "https://polisen.se/rss/blekinge-lan"),
        PoliceFeed(title: "Kronoberg", url: "https://polisen.se/rss/kronobergs-lan"),
        PoliceFeed(title: "Kalmar", url: "https://polisen.se/rss/kalmar-lan"),
    ],
    "Region Bergslagen": [
        PoliceFeed(title: "Värmland", url: "https://polisen.se/rss/varmlands-lan"),
        PoliceFeed(title: "Örebro", url: "https://polisen.se/rss/orebro-lan"),
        PoliceFeed(title: "Dalarna", url: "https://polisen.se/rss/dalarnas-lan"),
    ],
]
