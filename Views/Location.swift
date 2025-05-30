//
//  Location.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

//
//  Location.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct Location: View {
    @EnvironmentObject var viewModel: NewsViewModel
    @State private var expandedRegions: Set<String> = []

    var body: some View {
        List {
            Section(header: Text("Nationella flöden")) {
                ForEach(nationalFeeds) { feed in
                    let isChecked = feed.urls.allSatisfy { viewModel.selectedPoliceFeedURLs.contains($0) }

                    Button {
                        toggleFeed(urls: feed.urls, isChecked: isChecked)
                    } label: {
                        HStack {
                            Text(feed.title)
                            Spacer()
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isChecked ? .accentColor : .gray)
                        }
                    }
                }
            }

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
                    ),
                    content: {
                        ForEach(localFeeds[region] ?? []) { feed in
                            let isChecked = feed.urls.allSatisfy { viewModel.selectedPoliceFeedURLs.contains($0) }

                            Button {
                                toggleFeed(urls: feed.urls, isChecked: isChecked)
                            } label: {
                                HStack {
                                    Text(feed.title)
                                    Spacer()
                                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(isChecked ? .accentColor : .gray)
                                }
                            }
                        }
                    },
                    label: {
                        Text(region)
                            .font(.headline)
                    }
                )
            }
        }
        .navigationTitle("Välj flöden")
        .onDisappear {
            viewModel.loadNews()
        }
    }

    private func toggleFeed(urls: [String], isChecked: Bool) {
        if isChecked {
            viewModel.selectedPoliceFeedURLs.subtract(urls)
        } else {
            viewModel.selectedPoliceFeedURLs.formUnion(urls)
        }
    }
}

let nationalFeeds = [
    PoliceFeed(title: "Press – Nationella", urls: ["https://polisen.se/aktuellt/rss/hela-landet/press-rss---nationella/"]),
    PoliceFeed(title: "Pressmeddelanden – Hela landet", urls: ["https://polisen.se/aktuellt/rss/hela-landet/pressmeddelanden-hela-landet/"]),
    PoliceFeed(title: "Nyheter – Nationella", urls: ["https://polisen.se/aktuellt/rss/hela-landet/nyheter-rss---nationella/"])
]

let localFeeds: [String: [PoliceFeed]] = [
    "Region Nord": [
        PoliceFeed(title: "Jämtland", urls: [
            "https://polisen.se/aktuellt/rss/jamtland/nyheter-rss---jamtland/",
            "https://polisen.se/aktuellt/rss/jamtland/handelser-rss---jamtland/"
        ]),
        PoliceFeed(title: "Västerbotten", urls: [
            "https://polisen.se/aktuellt/rss/vasterbotten/nyheter-rss---vasterbotten/",
            "https://polisen.se/aktuellt/rss/vasterbotten/handelser-rss---vasterbotten/"
        ]),
        PoliceFeed(title: "Norrbotten", urls: [
            "https://polisen.se/aktuellt/rss/norrbotten/nyheter-rss---norrbotten/",
            "https://polisen.se/aktuellt/rss/norrbotten/handelser-rss---norrbotten/"
        ]),
        PoliceFeed(title: "Västernorrland", urls: [
            "https://polisen.se/aktuellt/rss/vasternorrland/nyheter-rss---vasternorrland/",
            "https://polisen.se/aktuellt/rss/vasternorrland/handelser-rss---vasternorrland/"
        ]),
    ],
    "Region Mitt": [
        PoliceFeed(title: "Gävleborg", urls: [
            "https://polisen.se/aktuellt/rss/gavleborg/nyheter-rss---gavleborg/",
            "https://polisen.se/aktuellt/rss/gavleborg/handelser-rss---gavleborg/"
        ]),

        PoliceFeed(title: "Uppsala", urls: [
            "https://polisen.se/aktuellt/rss/uppsala-lan/nyheter-rss---uppsala-lan/",
            "https://polisen.se/aktuellt/rss/uppsala-lan/handelser-rss---uppsala-lan/"
        ]),

        PoliceFeed(title: "Västmanland", urls: [
            "https://polisen.se/aktuellt/rss/vastmanland/nyheter-rss---vastmanland/",
            "https://polisen.se/aktuellt/rss/vastmanland/handalser-rss---vastmanland/"
        ]),

    ],
    "Region Stockholm": [
        PoliceFeed(title: "Stockholm", urls: [
            "https://polisen.se/aktuellt/rss/stockholms-lan/nyheter-rss---stockholms-lan/",
            "https://polisen.se/aktuellt/rss/stockholms-lan/handalser-rss---stockholms-lan/"
        ]),

        PoliceFeed(title: "Gotland", urls: [
            "https://polisen.se/aktuellt/rss/gotland/nyheter-rss---gotland/",
            "https://polisen.se/aktuellt/rss/gotland/handalser-rss---gotland/"
        ]),

    ],
    "Region Öst": [
        PoliceFeed(title: "Södermanland", urls: [
            "https://polisen.se/aktuellt/rss/sodermanland/nyheter-rss---sodermanland/",
            "https://polisen.se/aktuellt/rss/sodermanland/handalser-rss---sodermanland/"
        ]),

        PoliceFeed(title: "Östergötland", urls: [
            "https://polisen.se/aktuellt/rss/ostergotland/nyheter-rss---ostergotland/",
            "https://polisen.se/aktuellt/rss/ostergotland/handalser-rss---ostergotland/"
        ]),

        PoliceFeed(title: "Jönköping", urls: [
            "https://polisen.se/aktuellt/rss/jonkopings-lan/nyheter-rss---jonkopings-lan/",
            "https://polisen.se/aktuellt/rss/jonkopings-lan/handalser-rss---jonkopings-lan/"
        ]),
    ],
    "Region Väst": [
        PoliceFeed(title: "Halland", urls: [
            "https://polisen.se/aktuellt/rss/halland/nyheter-rss---halland/",
            "https://polisen.se/aktuellt/rss/halland/handalser-rss---halland/"
        ]),

        PoliceFeed(title: "Västra Götaland", urls: [
            "https://polisen.se/aktuellt/rss/vastra-gotaland/nyheter-rss---vastra-gotaland/",
            "https://polisen.se/aktuellt/rss/vastra-gotaland/handalser-rss---vastra-gotaland/"
        ]),

    ],
    "Region Syd": [
        PoliceFeed(title: "Skåne", urls: [
            "https://polisen.se/aktuellt/rss/skane/nyheter-rss---skane/",
            "https://polisen.se/aktuellt/rss/skane/handalser-rss---skane/"
        ]),

        PoliceFeed(title: "Blekinge", urls: [
            "https://polisen.se/aktuellt/rss/blekinge/nyheter-rss---blekinge/",
            "https://polisen.se/aktuellt/rss/blekinge/handalser-rss---blekinge/"
        ]),

        PoliceFeed(title: "Kronoberg", urls: [
            "https://polisen.se/aktuellt/rss/kronoberg/nyheter-rss---kronoberg/",
            "https://polisen.se/aktuellt/rss/kronoberg/handalser-rss---kronoberg/"
        ]),

        PoliceFeed(title: "Kalmar", urls: [
            "https://polisen.se/aktuellt/rss/kalmar-lan/nyheter-rss---kalmar-lan/",
            "https://polisen.se/aktuellt/rss/kalmar-lan/handalser-rss---kalmar-lan/"
        ]),

    ],
    "Region Bergslagen": [
        PoliceFeed(title: "Värmland", urls: [
            "https://polisen.se/aktuellt/rss/varmland/nyheter-rss---varmland/",
            "https://polisen.se/aktuellt/rss/varmland/handalser-rss---varmland/"
        ]),

        PoliceFeed(title: "Örebro", urls: [
            "https://polisen.se/aktuellt/rss/orebro-lan/nyheter-rss---orebro-lan/",
            "https://polisen.se/aktuellt/rss/orebro-lan/handalser-rss---orebro-lan/"
        ]),

        PoliceFeed(title: "Dalarna", urls: [
            "https://polisen.se/aktuellt/rss/dalarna/nyheter-rss---dalarna/",
            "https://polisen.se/aktuellt/rss/dalarna/handalser-rss---dalarna/"
        ]),
    ],
]
