//
//  AddCategory.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: NewsViewModel
    @State private var name = ""
    @State private var iconName = "square.grid.2x2"

    let symbols = ["newspaper", "star", "book", "bubble.left", "bolt", "sun.max", "flame", "pawprint", "leaf", "gamecontroller", "music.note", "theatermasks", "desktopcomputer"]

    var body: some View {
        Form {
            Section(header: Text("Namn")) {
                TextField("Kategori-namn", text: $name)
            }

            Section(header: Text("Symbol")) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(symbols, id: \.self) { symbol in
                            Button {
                                iconName = symbol
                            } label: {
                                Image(systemName: symbol)
                                    .font(.title2)
                                    .padding()
                                    .background(iconName == symbol ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Button("Lägg till") {
                let newCategory = Category(id: UUID(), name: name, iconName: iconName, isCustom: true)
                viewModel.customCategories.append(newCategory)
                dismiss()
            }
            .disabled(name.isEmpty)
        }
        .navigationTitle("Ny kategori")
    }
}
