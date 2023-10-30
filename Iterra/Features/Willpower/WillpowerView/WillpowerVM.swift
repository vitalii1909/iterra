//
//  WillpowerVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

@MainActor
class WillpowerVM: TaskVM {
    
    var service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol = WillpowerService()) {
        self.service = service
    }
    
    func fetch(taskArray: Binding<[BioWillpower]>, userId: String?) async throws {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        do {
            guard let array = try await service.fetch(userId: userId) as? [BioWillpower] else {
                return
            }
            taskArray.wrappedValue = array
        } catch let error {
            throw error
        }
    }
    
    func delete(task: BioTask, taskArray: Binding<[BioWillpower]>, userId: String?) async throws {
        guard let userId = userId else {
            throw TestError.userId
        }
        
        guard let documentId = task.id else {
            throw TestError.userId
        }
        
        do {
            try await service.delete(task: task, documentId: documentId, userId: userId)
            
            if let index = taskArray.firstIndex(where: {$0.id == documentId}) {
                taskArray.wrappedValue.remove(at: index)
            }
        } catch let error {
            throw error
        }
    }
}
