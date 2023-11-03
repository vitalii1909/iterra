//
//  WillpowerVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

@MainActor
class WillpowerVM: TaskVM {
    
    private var service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol = WillpowerService()) {
        self.service = service
    }
    
    func fetch(taskArray: Binding<[BioWillpower]>) async throws {
        do {
            guard let array = try await service.fetch() as? [BioWillpower] else {
                return
            }
            taskArray.wrappedValue = array
        } catch let error {
            throw error
        }
    }
    
    func moveToBio(task: BioTask, timersArray: Binding<[BioWillpower]>, accepted: Bool) async throws {
        
        guard let documentId = task.id else {
            throw TestError.userId
        }
        
        if let index = timersArray.firstIndex(where: {$0.id == documentId}) {
            let task = timersArray.wrappedValue[index]
            Task {
                do {
                    try await service.moveToBio(task: task, accepted: accepted)
                    timersArray.wrappedValue.remove(at: index)
                } catch let error {
                   print("error \(error)")
                }
            }
            
            
        }
    }
    
    func delete(task: BioTask, taskArray: Binding<[BioWillpower]>) async throws {
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
