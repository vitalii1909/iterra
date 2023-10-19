//
//  AppTabView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI

class TaskStore: ObservableObject {
    @Published var stopwatchArray = [TaskModel]() {
        didSet {
            saveStopwatch()
        }
    }

    @Published var timersArray = [TaskModel]() {
        didSet {
            saveTimers()
        }
    }
    
    @Published var patience2Array = [TaskModel]() {
        didSet {
            savePatience2()
        }
    }
    
    init() {
        fetchTimers()
        fetchStopwatch()
        fetchPatience2()
    }
    
    func saveTimers() {
        if let encoded = try? JSONEncoder().encode(timersArray) {
            UserDefaults.standard.set(encoded, forKey: "timersArray")
        }
    }
    
    func saveStopwatch() {
        if let encoded = try? JSONEncoder().encode(stopwatchArray) {
            UserDefaults.standard.set(encoded, forKey: "stopwatchArray")
        }
    }
    
    func savePatience2() {
        if let encoded = try? JSONEncoder().encode(patience2Array) {
            UserDefaults.standard.set(encoded, forKey: "patience2Array")
        }
    }
    
    func fetchTimers() {
        guard let data = UserDefaults.standard.value(forKey: "timersArray") as? Data,
                    let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
                    else { return }
        timersArray = decodedData
    }
    
    func fetchStopwatch() {
        guard let data = UserDefaults.standard.value(forKey: "stopwatchArray") as? Data,
                    let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
                    else { return }
        stopwatchArray = decodedData
    }
    
    func fetchPatience2() {
        guard let data = UserDefaults.standard.value(forKey: "patience2Array") as? Data,
                    let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
                    else { return }
        patience2Array = decodedData
    }
}

struct AppTabView: View {
    
    @State var currentScreen: AppScreen = .timer
    @State var showInput = false
    
    @StateObject var taskStore = TaskStore()
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            TabView(selection: $currentScreen,
                    content:  {
                ForEach(AppScreen.allCases) { screen in
                    screen.destination
                        .tag(screen as AppScreen?)
                        .tabItem { screen.label }
                        .environmentObject(taskStore)
                }
            })
        })
    }
}

#Preview {
    AppTabView()
        .environmentObject(TaskStore())
}
