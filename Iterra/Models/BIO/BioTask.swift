//
//  BioTask.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import Foundation

class BioTask: BioModel {
    
    var text: String
    var startDate: Date
    var stopDate: Date?
    
    init(id: String? = nil, text: String, startDate: Date, stopDate: Date?, date: Date) {
        self.text = text
        self.startDate = startDate
        self.stopDate = stopDate
        super.init(id: id, date: date)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        startDate = try container.decode(Date.self, forKey: .startDate)
        stopDate = try container.decode(Date?.self, forKey: .stopDate)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(text, forKey: .text)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(stopDate, forKey: .stopDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case text
        case startDate
        case stopDate
    }
}
