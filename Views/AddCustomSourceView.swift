//
//  AddCustomSourceView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import SwiftUI

struct AddCustomSourceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: NewsViewModel
    @AppStorage("appLanguage") private var appLanguage = "sv"

    @State private var name = ""
    @State private var urlString = ""
    @State private var selectedIcon = "newspaper"

    let category: Category
    let customCategory: CustomCategory?

    private let availableIcons = [
        "newspaper", "bolt", "star", "flame", "leaf", "globe", "waveform", "building.columns",
        "book", "film", "tv", "sportscourt", "soccerball", "dollarsign.circle",
        "lightbulb", "heart", "cross.case", "stethoscope", "bandage", "graduationcap",
        "theatermasks", "music.note", "camera", "car", "tram", "airplane", "bicycle", "ferry",
        "hammer", "wrench", "desktopcomputer", "cpu", "antenna.radiowaves.left.and.right",
        "shield", "lock.shield", "person.3", "person.crop.circle", "chart.line.uptrend.xyaxis",
        "chart.pie", "map", "doc.text", "doc.text.magnifyingglass", "clock", "calendar",
        "building", "house", "drop", "globe.americas", "tornado", "sun.max", "cloud.rain", "snowflake",
        "exclamationmark.triangle", "checkmark.shield", "envelope", "message", "bubble.left.and.bubble.right",
        "questionmark.circle", "magnifyingglass", "link", "paperplane", "bell", "megaphone"
    ]

    var body: some View {
        Form {
            Section(header: Text(appLanguage == "sv" ? "Namn" : "Name")) {
                TextField(appLanguage == "sv" ? "Namn" : "Name", text: $name)
            }

            Section(header: Text("RSS URL")) {
                TextField(appLanguage == "sv" ? "Ange giltig RSS-länk (https://example.com/rss)" : "Enter valid RSS url (https://example.com/rss)", text: $urlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .textContentType(.URL)
                    .foregroundColor(.primary)
            }

            Section(header: Text("Symbol")) {
                Menu {
                    ForEach(availableIcons, id: \.self) { icon in
                        Button {
                            selectedIcon = icon
                        } label: {
                            Label {
                                Text(icon)
                            } icon: {
                                Image(systemName: icon)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(appLanguage == "sv" ? "Vald symbol:" : "Selected symbol:")
                        Spacer()
                        Image(systemName: selectedIcon)
                            .font(.title2)
                            .padding(6)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }

            Button(appLanguage == "sv" ? "Lägg till" : "Add") {
                if let url = URL(string: urlString), !name.isEmpty {
                    let newSource = NewsSource(name: name, logo: selectedIcon, url: url, isCustom: true)

                    if let custom = customCategory {
                        viewModel.customCategorySources[custom.id, default: []].append(newSource)
                    } else {
                        viewModel.customSources[category, default: []].append(newSource)
                    }

                    viewModel.activeSources.insert(name)
                    dismiss()
                }
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || URL(string: urlString) == nil)
        }
        .navigationTitle(appLanguage == "sv" ? "Lägg till källa" : "Add custom source")
    }
}
