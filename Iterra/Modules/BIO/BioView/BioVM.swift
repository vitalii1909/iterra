//
//  BioVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

class BioVM: ObservableObject {
    func getDict(array: [TaskModel]) -> [Date : [TaskModel]]? {
        let array = array.filter({$0.finished == true}).sorted(by: {$0.deadline > $1.deadline})
        let grouped = array.sliced(by: [.year, .month, .day], for: \.deadline)
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
}
