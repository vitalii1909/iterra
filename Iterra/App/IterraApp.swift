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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
        }
    }
}
