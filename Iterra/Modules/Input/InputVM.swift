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
    
    func createTask() -> BioModel {
        switch type {
        case .willpower:
            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), deadline: selectedDate, finished: false, text: text, accepted: false)
            return task
        case .patience:
//            task.date = Date()
//            task.deadline = selectedDate
            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, deadline: selectedDate, finished: false, text: text, accepted: false)
            return task
        case .cleanTime:
//            task.date = Date()
//            task.deadline = selectedDate
            let task = BioWillpower(id: UUID().uuidString, startDate: Date(), stopDate: selectedDate, deadline: selectedDate, finished: false, text: text, accepted: false)
            return task
        }
    }
}
