//
//  BioWillpower.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioWillpower: BioTask {
    
    var text: String
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, date: Date, text: String, accepted: Bool) {
        
        self.text = text
        
        super.init(id: id, startDate: startDate, stopDate: stopDate, date: date, accepted: accepted)
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

extension BioWillpower {
    static func mocData() -> BioWillpower {
        BioWillpower(id: UUID().uuidString, startDate: Date(), date: Date(), text: "test text", accepted: false)
    }
    
    static func mocArray() -> [BioWillpower] {
        [mocData(),mocData(),mocData(),mocData(),mocData()]
    }
}
