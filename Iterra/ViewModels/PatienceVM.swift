//
//  PatienceVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-16.
//

import SwiftUI

@MainActor
class PatienceVM: TaskVM {
    
    private var service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol = PatienceService()) {
        self.service = service
    }
    
    func fetch(taskArray: Binding<[BioPatience]>) async throws {
        do {
            guard let array = try await service.fetch() as? [BioPatience] else {
                throw TestError.dbError
            }
            taskArray.wrappedValue = array
        } catch let error {
            throw error
        }
    }
    
    func moveToBio(task: BioTask, patienceArray: Binding<[BioPatience]>, accepted: Bool) async throws {
        
        guard let documentId = task.id else {
            throw TestError.userId
        }
        
        
        if let index = patienceArray.firstIndex(where: {$0.id == documentId}) {
            let task = patienceArray.wrappedValue[index]
            Task {
                do {
                    try await service.moveToBio(task: task, accepted: accepted)
                    patienceArray.wrappedValue.remove(at: index)
                } catch let error {
                   print("error \(error)")
                }
            }
            
            
        }
    }
    
    func delete(task: BioTask, taskArray: Binding<[BioPatience]>) async throws {
        guard let documentId = task.id else {
            throw TestError.userId
        }
        
        do {
            try await service.delete(task: task, documentId: documentId)
            
            if let index = taskArray.firstIndex(where: {$0.id == documentId}) {
                taskArray.wrappedValue.remove(at: index)
            }
        } catch let error {
            throw error
        }
    }
}


class TaskVM: ObservableObject {
    func getDict(array: [BioTask]) -> [Date : [BioTask]]? {
//        let array = array.filter({$0.finished == false}).sorted(by: {$0.date > $1.date})
        let array = array.sorted(by: {$0.date > $1.date})
        //FIXME: remove force
        let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
}
