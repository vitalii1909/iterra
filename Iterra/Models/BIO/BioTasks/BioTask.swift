//
//  BioTask.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import Foundation

class BioTask: BioModel {
    
    var startDate: Date
    var stopDate: Date?
    var accepted: Bool
    
    init(id: String? = nil, startDate: Date, stopDate: Date?, date: Date, accepted: Bool) {
        self.startDate = startDate
        self.stopDate = stopDate
        self.accepted = accepted
        super.init(id: id, date: date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try container.decode(Date.self, forKey: .startDate)
        stopDate = try container.decode(Date?.self, forKey: .stopDate)
        accepted = try container.decode(Bool.self, forKey: .accepted)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(stopDate, forKey: .stopDate)
        try container.encode(accepted, forKey: .accepted)
    }
    
    enum CodingKeys: String, CodingKey {
        case startDate
        case stopDate
        case accepted
    }
}
