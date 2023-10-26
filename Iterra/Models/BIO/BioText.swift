//
//  BioText.swift
//  Iterra
//
//  Created by mikhey on 2023-10-24.
//

import Foundation
import FirebaseFirestoreSwift

class BioText: BioModel {
    
    var text: String
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, deadline: Date, finished: Bool, text: String) {
        self.text = text
        super.init(id: id, startDate: startDate, stopDate: stopDate, deadline: deadline, finished: finished)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(text, forKey: .text)
    }
    
    enum CodingKeys: String, CodingKey {
        case text
    }
}

