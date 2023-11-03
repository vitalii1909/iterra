//
//  BioPatience.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioPatience: BioTask {
    
    var waited: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, date: Date, text: String, waited: Bool) {
        self.waited = waited
        
        super.init(id: id,text: text, startDate: startDate, stopDate: stopDate, date: date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        waited = try container.decode(Bool.self, forKey: .waited)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(waited, forKey: .waited)
    }
    
    enum CodingKeys: String, CodingKey {
        case waited
    }
}

extension BioPatience {
    static func mocData() -> BioPatience {
        return BioPatience(id: UUID().uuidString, startDate: Date(), stopDate: Date(), date: Date.tomorrow, text: "test text", waited: false)
    }
}
