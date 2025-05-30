//
//  Filter.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-30.
//

import SwiftUI

struct Filter: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: NewsViewModel
    @AppStorage("appLanguage") private var appLanguage = "sv"

    var body: some View {
        List {
            ForEach(viewModel.currentCategory.sources) { source in
                Button {
                    toggle(source)
                } label: {
                    HStack {
                        if let logo = source.logo {
                            Image(logo)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo")
                                .frame(width: 24, height: 24)
                                .foregroundColor(.gray)
                        }

                        Text(source.name)
                            .padding(.leading, 4)

                        Spacer()

                        Image(systemName: viewModel.activeSources.contains(source.name) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.accentColor)
                    }

                }
            }
        }
        .navigationTitle(appLanguage == "sv" ? "Välj källor" : "Choose Sources")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(appLanguage == "sv" ? "Klar" : "Done") {
                    viewModel.loadNews()
                    dismiss()
                }
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
}
