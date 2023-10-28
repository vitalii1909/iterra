//
//  BioWillpower.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioWillpower: BioTask {
    
    var text: String
    var accepted: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, date: Date, finished: Bool, text: String, accepted: Bool) {
        
        self.text = text
        self.accepted = accepted
        
        super.init(id: id, startDate: startDate, stopDate: stopDate, date: date, finished: finished)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        accepted = try container.decode(Bool.self, forKey: .accepted)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(text, forKey: .text)
        try container.encode(accepted, forKey: .accepted)
    }
    
    enum CodingKeys: String, CodingKey {
        case text
        case accepted
    }
}

extension BioWillpower {
    static func mocData() -> BioWillpower {
        BioWillpower(id: UUID().uuidString, startDate: Date(), date: Date(), finished: false, text: "test text", accepted: false)
    }
    
    static func mocArray() -> [BioWillpower] {
        [mocData(),mocData(),mocData(),mocData(),mocData()]
    }
}
