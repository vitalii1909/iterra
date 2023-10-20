//
//  TaskModel.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import Foundation

enum TaskType: String, Codable {
    case willpower
    case patience
    case cleanTime
}

class TaskModel: Codable, Equatable {
    let id: String
    let type: TaskType
    var date: Date
    let text: String
    var finished: Bool = false
    var accepted: Bool = false
    
    var stopDate: Date?
    var deadline: Date
    
    init(id: String, type: TaskType, date: Date, text: String, deadline: Date = Date.tomorrow) {
        self.id = id
        self.type = type
        self.date = date
        self.text = text
        self.deadline = deadline
    }
    
    static func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.date == rhs.date &&
        lhs.text == rhs.text &&
        lhs.finished == rhs.finished &&
        lhs.accepted == rhs.accepted &&
        lhs.stopDate == rhs.stopDate &&
        lhs.deadline == rhs.deadline
    }
    
    static func mocData(type: TaskType) -> TaskModel {
        TaskModel(id: UUID().uuidString, type: type, date: Date.tomorrow, text: "moc text")
    }
    
    static func mocArray(type: TaskType) -> [TaskModel] {
        [mocData(type: type),mocData(type: type),mocData(type: type),mocData(type: type),mocData(type: type)]
    }
}

//FIXME: move to ext
extension Date {
   static var tomorrow:  Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}

