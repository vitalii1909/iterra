//
//  AppScreen.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case timer
    case stopwatch
    case patience2
    case bio
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .timer:
            Label("Willpower", systemImage: "timer")
        case .stopwatch:
            Label("Patience", systemImage: "stopwatch")
        case .patience2:
            Label("Patience2", systemImage: "stopwatch")
        case .bio:
            Label("BIO", systemImage: "person")
        }
    }
    
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .timer:
            TimersNavigationStack()
        case .stopwatch:
            StopwatchsNavigationStack()
        case .patience2:
            PatienceNavigationStack()
        case .bio:
            BioNavigationStack()
        }
    }
}
