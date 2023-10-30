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
