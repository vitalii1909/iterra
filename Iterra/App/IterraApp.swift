//
//  IterraApp.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI
import FirebaseCore

@main
struct IterraApp: App {
    
    @StateObject var appStateManager: AppStateManager = .init()
    @StateObject var userService = UserFirebaseRepository()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            appContent
                .task {
                    Task() {
                        let user = await userService.fetchUser()
                        await appStateManager.configApp(user: user)
                    }
                }
        }
    }
    
    @ViewBuilder
    var appContent: some View {
        switch appStateManager.appState {
        case .loading:
            Text("loading...")
        case .main:
            AppTabView()
                .environmentObject(userService)
        case .registration:
            LoginView()
                .environmentObject(appStateManager)
                .environmentObject(userService)
        }
    }
}
