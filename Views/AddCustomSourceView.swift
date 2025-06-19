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

    let category: Category

    var body: some View {
        Form {
            Section(header: Text(appLanguage == "sv" ? "Namn" : "Name")) {
                TextField("RSS-namn", text: $name)
            }

            Section(header: Text("RSS URL")) {
                TextField("https://exempel.se/rss", text: $urlString)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }

            Button(appLanguage == "sv" ? "Lägg till" : "Add") {
                if let url = URL(string: urlString), !name.isEmpty {
                    let newSource = NewsSource(name: name, logo: nil, url: url, isCustom: true)
                    viewModel.customSources[category, default: []].append(newSource)
                    viewModel.activeSources.insert(name)
                    dismiss()
                }
            }
            .disabled(name.isEmpty || URL(string: urlString) == nil)
        }
        .navigationTitle(appLanguage == "sv" ? "Ny källa" : "New Source")
    }
}
