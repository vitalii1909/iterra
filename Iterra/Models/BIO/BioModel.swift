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
    
    var date: Date
    
    init(id: String? = nil, date: Date) {
        self.id = id
        self.date = date
    }
}
