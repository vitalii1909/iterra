//
//  AppScreen.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case timer
    case patience
    case clean
    case bio
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .timer:
            Label("Willpower", systemImage: "timer")
        case .clean:
            Label("Clean", systemImage: "clear")
        case .patience:
            Label("Patience", systemImage: "stopwatch")
        case .bio:
            Label("BIO", systemImage: "person")
        }
    }
    
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .timer:
            WillpowerNavigationStack()
        case .clean:
            CleanTimeNavigationStack()
        case .patience:
            PatienceNavigationStack()
        case .bio:
            BioNavigationStack()
        }
    }
}
