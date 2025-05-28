//
//  AppVersion.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct AppVersion: View {
    var body: some View {
        Section {
            EmptyView()
        } footer: {
            VStack(spacing: 4) {
                Text(appVersion)
                Text("© 2025 Univert App")
                Text("Github.com/AdrianNeshad")
                Text("Linkedin.com/in/adrian-neshad")
            }
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var appVersion: String {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"
            return "Version \(version) (\(build))"
        }
}

