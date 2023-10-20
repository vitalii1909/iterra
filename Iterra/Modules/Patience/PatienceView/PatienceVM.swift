//
//  PatienceVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-16.
//

import SwiftUI

class PatienceVM: TaskVM {
    
    
}


class TaskVM: ObservableObject {
    func getDict(array: [TaskModel]) -> [Date : [TaskModel]]? {
        let array = array.filter({$0.finished == false}).sorted(by: {$0.deadline > $1.deadline})
        //FIXME: remove force
        let grouped = array.sliced(by: [.year, .month, .day], for: \.deadline)
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
}
