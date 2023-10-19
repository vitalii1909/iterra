//
//  TaskModel.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import Foundation

enum TaskType: String, Codable {
    case timer
    case stopwatch
    case patience2
}

class TaskModel: Codable {
    let id: String
    let type: TaskType
    var date: Date
    let text: String
    var finished: Bool = false
    var accepted: Bool = false
    
    var stopDate: Date?
    var deadline: Date?
    
    init(id: String, type: TaskType, date: Date, text: String) {
        self.id = id
        self.type = type
        self.date = date
        self.text = text
    }
    
    static func mocData(type: TaskType) -> TaskModel {
        TaskModel(id: UUID().uuidString, type: type, date: Date(), text: "moc text")
    }
    
    static func mocArray(type: TaskType) -> [TaskModel] {
        [mocData(type: type),mocData(type: type),mocData(type: type),mocData(type: type),mocData(type: type)]
    }
}
