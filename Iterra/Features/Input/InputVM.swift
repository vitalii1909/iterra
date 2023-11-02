//
//  InputVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI

@MainActor
class InputVM: ObservableObject {
    
    @Published var text = ""
    
    @Published var selectedDate = Date()
    
    @Published var localArray = [BioTask]()
    
    let type: TaskType
    
    init(type: TaskType) {
        self.type = type
    }
    
    func createTask() -> BioTask {
        switch type {
        case .willpower:
            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), date: selectedDate, text: text, done: false)
            return task
        case .patience:
            let task = BioPatience(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, date: selectedDate, text: text, waited: false)
            return task
        case .cleanTime:
            let task = BioClean(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, date: selectedDate, text: text, failed: false)
            return task
        }
    }
    
//    func add(userId: String?) async throws {
//        switch type {
//        case .willpower:
////            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, date: selectedDate, finished: false, text: text, accepted: false)
//            let service = WillpowerService()
//            for task in localArray {
//                try await service.add(task: task, userId: userId)
//            }
//            print("willpower sanded")
//        case .patience:
////            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, date: selectedDate, finished: false, text: text, accepted: false)
//            print("w")
//        case .cleanTime:
////            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, date: selectedDate, finished: false, text: text, accepted: false)
//            print("w")
//        }
//    }
    
    func addWillpower(array: Binding<[BioWillpower]>) async throws {
        let service = WillpowerService()
        for task in localArray {
            if let willpower = task as? BioWillpower {
               let docRef = try await service.add(task: task)
                willpower.id = docRef.documentID
                array.wrappedValue.append(willpower)
            }
        }
    }
    
    func addPatience(array: Binding<[BioPatience]>) async throws {
        let service = PatienceService()
        for task in localArray {
            if let willpower = task as? BioPatience {
               let docRef = try await service.add(task: task)
                willpower.id = docRef.documentID
                array.wrappedValue.append(willpower)
            }
        }
    }
    
    func addClean(array: Binding<[BioClean]>) async throws {
        let service = CleanService()
        for task in localArray {
            if let clean = task as? BioClean {
               let docRef = try await service.add(task: task)
                clean.id = docRef.documentID
                array.wrappedValue.append(clean)
            }
        }
    }
}
