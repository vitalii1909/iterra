//
//  BioWillpower.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioWillpower: BioTask {
    
    var done: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, date: Date, text: String, done: Bool) {
        self.done = done
        
        super.init(id: id,text: text, startDate: startDate, stopDate: stopDate, date: date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        done = try container.decode(Bool.self, forKey: .done)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(done, forKey: .done)
    }
    
    enum CodingKeys: String, CodingKey {
        case done
    }
}

extension BioWillpower {
    static func mocData() -> BioWillpower {
        BioWillpower(id: UUID().uuidString, startDate: Date(), date: Date(), text: "test text", done: false)
    }
    
    static func mocArray() -> [BioWillpower] {
        [mocData(),mocData(),mocData(),mocData(),mocData()]
    }
}
