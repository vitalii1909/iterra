//
//  AppTabView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI
import Combine

class TaskStore: ObservableObject {
    @Published var timersArray = [TaskModel]() {
        didSet {
            saveTimers()
        }
    }
    
    @Published var patienceArray = [TaskModel]() {
        didSet {
            savePatience2()
        }
    }
    
    @Published var cleanTimeArray = [TaskModel]() {
        didSet {
            saveStopwatch()
        }
    }
    
    private var tickets: [AnyCancellable] = []
    
    init() {
        fetchTimers()
        fetchStopwatch()
        fetchPatience2()
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.count() }
            .store(in: &tickets)
    }
    
    private func count() {
//        let expiredArray = patienceArray.filter({$0.finished == false}).filter({$0.deadline < Date()})
//        if expiredArray.count > 0 {
//            for i in expiredArray {
//                if let index = patienceArray.firstIndex(where: {$0.id == i.id}) {
//                    let task = patienceArray[index]
//                    task.finished = true
//                    task.accepted = true
//                    task.stopDate = Date()
//                    withAnimation(.spring) {
//                        patienceArray[index] = task
//                    }
//                }
//            }
//        }
//        
//        updateTimers()
    }
    
    //clear test
    private func updateTimers() {
        let expiredArray = timersArray.filter({$0.finished == false}).filter({$0.deadline < Date()})
        if expiredArray.count > 0 {
            for i in expiredArray {
                if let index = timersArray.firstIndex(where: {$0.id == i.id}) {
                    let task = timersArray[index]
                    task.finished = true
                    task.accepted = false
                    task.stopDate = Date()
                    withAnimation(.spring) {
                        timersArray[index] = task
                    }
                }
            }
        }
    }
    //clear test
    
    func saveTimers() {
        if let encoded = try? JSONEncoder().encode(timersArray) {
            UserDefaults.standard.set(encoded, forKey: "timersArray")
        }
    }
    
    func saveStopwatch() {
        if let encoded = try? JSONEncoder().encode(cleanTimeArray) {
            UserDefaults.standard.set(encoded, forKey: "cleanTimeArray")
        }
    }
    
    func savePatience2() {
        if let encoded = try? JSONEncoder().encode(patienceArray) {
            UserDefaults.standard.set(encoded, forKey: "patienceArray")
        }
    }
    
    func fetchTimers() {
        guard let data = UserDefaults.standard.value(forKey: "timersArray") as? Data,
              let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
        else { return }
        timersArray = decodedData
    }
    
    func fetchStopwatch() {
        guard let data = UserDefaults.standard.value(forKey: "cleanTimeArray") as? Data,
              let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
        else { return }
        cleanTimeArray = decodedData
    }
    
    func fetchPatience2() {
        guard let data = UserDefaults.standard.value(forKey: "patienceArray") as? Data,
              let decodedData = try? JSONDecoder().decode([TaskModel].self, from: data)
        else { return }
        patienceArray = decodedData
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
