//
//  CleanTimeVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-13.
//

import SwiftUI

@MainActor
class CleanTimeVM: TaskVM {
    private var service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol = CleanService()) {
        self.service = service
    }
    
    func fetch(taskArray: Binding<[BioClean]>) async throws {
        do {
            guard let array = try await service.fetch() as? [BioClean] else {
                return
            }
            taskArray.wrappedValue = array
        } catch let error {
            throw error
        }
    }
    
    func moveToBio(task: BioTask, cleanArray: Binding<[BioClean]>, accepted: Bool) async throws {
        
        guard let documentId = task.id else {
            throw TestError.userId
        }
        
        
        if let index = cleanArray.firstIndex(where: {$0.id == documentId}) {
            let task = cleanArray.wrappedValue[index]
            Task {
                do {
                    try await service.moveToBio(task: task, accepted: accepted)
                    cleanArray.wrappedValue.remove(at: index)
                } catch let error {
                   print("error \(error)")
                }
            }
            
            
        }
    }
    
    func delete(task: BioTask, taskArray: Binding<[BioClean]>) async throws {
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
