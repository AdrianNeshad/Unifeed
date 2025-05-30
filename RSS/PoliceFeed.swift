//
//  PoliceFeed.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-30.
//

import Foundation

struct PoliceFeed: Identifiable {
    let id = UUID()
    let title: String
    let urls: [String]
}
