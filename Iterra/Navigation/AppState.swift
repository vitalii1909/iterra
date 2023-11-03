//
//  AppState.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import Foundation

enum AppState {
    case loading
    case main
    case registration
}

@MainActor
class AppStateManager: ObservableObject {
    
    @Published var appState: AppState = .loading
    
    func configApp(user: User?) async {
        if let _ = user {
            appState = .main
        } else {
            appState = .registration
        }
    }
    
}
