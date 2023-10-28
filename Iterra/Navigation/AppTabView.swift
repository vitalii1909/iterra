//
//  AppTabView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI
import Combine

import Firebase

class StoreManager: ObservableObject {
    @Published var timersArray = [BioWillpower]()
    
    @Published var patienceArray = [BioPatience]() {
        didSet {
            savePatience2()
        }
    }
    
    @Published var cleanTimeArray = [BioClean]() {
        didSet {
            saveStopwatch()
        }
    }
    
    @Published var bioArray = [BioModel]()
    
    private var tickets: [AnyCancellable] = []
    
    init() {
        fetchTimers()
        fetchStopwatch()
        fetchPatience2()
        
        $timersArray
            .sink { [weak self] value in
                print("get value \(value.count)")
                self?.saveTimers(value: value)
            }
            .store(in: &tickets)
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.count() }
            .store(in: &tickets)
    }
    
    private func count() {
        let expiredArray = patienceArray.filter({$0.finished == false}).filter({$0.date < Date()})
        if expiredArray.count > 0 {
            for i in expiredArray {
                if let index = patienceArray.firstIndex(where: {$0.id == i.id}) {
                    let task = patienceArray[index]
                    task.finished = true
                    task.accepted = true
                    task.stopDate = Date()
                    withAnimation(.spring) {
                        patienceArray[index] = task
                    }
                }
            }
        }
        
        updateTimers()
    }
    
    //clear test
    private func updateTimers() {
        let expiredArray = timersArray.filter({$0.finished == false}).filter({$0.date < Date()})
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
    
    func saveTimers(value: [BioWillpower]) {
        let a = timersArray
        
        if !value.isEmpty {
            do {
                let encoded = try JSONEncoder().encode(timersArray)
                UserDefaults.standard.set(encoded, forKey: "timersArray")
            } catch let error {
                print("errrrrr \(error)")
            }
        }
        
        
//        if let encoded = try? Firestore.Encoder().encode(timersArray) {
//            UserDefaults.standard.set(encoded, forKey: "timersArray")
//        }
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
              let decodedData = try? JSONDecoder().decode([BioWillpower].self, from: data)
        else { return }
        timersArray = decodedData
    }
    
    func fetchStopwatch() {
        guard let data = UserDefaults.standard.value(forKey: "cleanTimeArray") as? Data,
              let decodedData = try? JSONDecoder().decode([BioClean].self, from: data)
        else { return }
        cleanTimeArray = decodedData
    }
    
    func fetchPatience2() {
        guard let data = UserDefaults.standard.value(forKey: "patienceArray") as? Data,
              let decodedData = try? JSONDecoder().decode([BioPatience].self, from: data)
        else { return }
        patienceArray = decodedData
    }
}

struct AppTabView: View {
    
    @State var currentScreen: AppScreen = .timer
    @State var showInput = false
    
    @StateObject var taskStore = StoreManager()
    
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
        .onAppear {
            
        }
    }
}

#Preview {
    AppTabView()
        .environmentObject(StoreManager())
}

extension Encodable {
    var dictionary: [String: Any]? {
        do {
            let encoded = try Firestore.Encoder().encode(self)
            return encoded
        } catch let error {
            print("wwwww \(error)")
            return nil
        }
    }
}

extension UserDefaults {
    func decode<T: Decodable>(_ type: T.Type, forKey defaultName: String) throws -> T {
//        try! JSONDecoder().decode(T.self, from: data(forKey: defaultName) ?? .init())
        try! Firestore.Decoder().decode(T.self, from: data(forKey: defaultName) ?? .init())
    }
    func encode<T: Encodable>(_ value: T, forKey defaultName: String) throws {
//        try! set(JSONEncoder().encode(value), forKey: defaultName)
        try! set(Firestore.Encoder().encode(value), forKey: defaultName)
    }
}
