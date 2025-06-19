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

    private let availableIcons = ["newspaper", "bolt", "star", "flame", "leaf", "globe", "waveform", "building.columns", "book", "film", "tv", "sportscourt", "soccerball", "dollarsign.circle", "swift"]

    var body: some View {
        Form {
            Section(header: Text(appLanguage == "sv" ? "Namn" : "Name")) {
                TextField(appLanguage == "sv" ? "Kategori" : "Category", text: $name)
            }

            Section(header: Text(appLanguage == "sv" ? "Symbol" : "Symbol")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(availableIcons, id: \.self) { iconName in
                            Button {
                                icon = iconName
                            } label: {
                                Image(systemName: iconName)
                                    .font(.title)
                                    .padding()
                                    .background(icon == iconName ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                        }
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
