//
//  BioClean.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioClean: BioTask {
    
    var failed: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date? = nil, date: Date, text: String, failed: Bool) {
        self.failed = failed
        
        super.init(id: id,text: text, startDate: startDate, stopDate: stopDate, date: date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        failed = try container.decode(Bool.self, forKey: .failed)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(failed, forKey: .failed)
    }
    
    enum CodingKeys: String, CodingKey {
        case failed
    }
}

extension BioClean {
    static func mocData() -> BioClean {
        return BioClean(id: UUID().uuidString, startDate: Date(), stopDate: Date(), date: Date(), text: "test text", failed: false)
    }
}
