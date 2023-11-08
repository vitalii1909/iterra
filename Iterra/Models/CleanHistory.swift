//
//  CleanHistory.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import Foundation
import FirebaseFirestoreSwift

class CleanHistory: Codable, Identifiable {
    @DocumentID var id: String?
    
    var date: Date
    var text: String
    
    init(id: String? = nil, date: Date, text: String) {
        self.id = id
        self.date = date
        self.text = text
    }
}
