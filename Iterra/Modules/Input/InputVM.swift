//
//  InputVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI

class InputVM: ObservableObject {
    
    @Published var text = ""
    
    @Published var selectedDate = Date()
    
    let type: TaskType
    
    init(type: TaskType) {
        self.type = type
    }
    
    func createTask() -> TaskModel {
        
        
        let task = TaskModel(id: UUID().uuidString, type: type, date: selectedDate, text: text)
        
        switch type {
        case .willpower:
            task.date = selectedDate
            task.deadline = selectedDate
        case .patience:
            task.date = Date()
            task.deadline = Date()
        case .cleanTime:
            task.date = Date()
            task.deadline = selectedDate
        }
    
        return task
    }
}
