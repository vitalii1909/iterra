//
//  BioModel.swift
//  Iterra
//
//  Created by mikhey on 2023-10-24.
//

import Foundation
import FirebaseFirestoreSwift

class BioModel: Codable, Identifiable {
    @DocumentID var id: String?
    
    var startDate: Date
    var stopDate: Date?
    var deadline: Date
    
    var finished: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, deadline: Date, finished: Bool) {
        self.id = id
        self.startDate = startDate
        self.stopDate = stopDate
        self.deadline = deadline
        self.finished = finished
    }
}
