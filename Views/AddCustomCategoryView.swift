//
//  AddCustomCategoryView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import SwiftUI

struct AddCustomCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: NewsViewModel
    @AppStorage("appLanguage") private var appLanguage = "sv"

    @State private var name = ""
    @State private var icon = "newspaper"

    private let availableIcons = [
        "newspaper", "bolt", "star", "flame", "leaf", "globe", "waveform", "building.columns",
        "book", "film", "tv", "sportscourt", "soccerball", "dollarsign.circle", "swift",
        "lightbulb", "heart", "cross.case", "stethoscope", "bandage", "graduationcap",
        "theatermasks", "music.note", "camera", "car", "tram", "airplane", "bicycle", "ferry",
        "hammer", "wrench", "desktopcomputer", "iphone", "cpu", "antenna.radiowaves.left.and.right",
        "shield", "lock.shield", "person.3", "person.crop.circle", "chart.line.uptrend.xyaxis",
        "chart.pie", "map", "doc.text", "doc.text.magnifyingglass", "clock", "calendar",
        "building", "house", "drop", "globe.americas", "tornado", "sun.max", "cloud.rain", "snowflake",
        "exclamationmark.triangle", "checkmark.shield", "envelope", "message", "bubble.left.and.bubble.right",
        "questionmark.circle", "magnifyingglass", "link", "paperplane", "bell", "megaphone", "apps.iphone"
    ]

    var body: some View {
        Form {
            Section(header: Text(appLanguage == "sv" ? "Namn" : "Name")) {
                TextField(appLanguage == "sv" ? "Kategori" : "Category", text: $name)
            }

            Section(header: Text(appLanguage == "sv" ? "Symbol" : "Symbol")) {
                Menu {
                    ForEach(availableIcons, id: \.self) { iconName in
                        Button {
                            icon = iconName
                        } label: {
                            Label {
                                Text(iconName)
                            } icon: {
                                Image(systemName: iconName)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(appLanguage == "sv" ? "Vald symbol:" : "Selected symbol:")
                        Spacer()
                        Image(systemName: icon)
                            .font(.title2)
                            .padding(6)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }

            Button(appLanguage == "sv" ? "Lägg till" : "Add") {
                viewModel.addCustomCategory(name: name, icon: icon)
                dismiss()
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .navigationTitle(appLanguage == "sv" ? "Ny kategori" : "New Category")
    }
}
