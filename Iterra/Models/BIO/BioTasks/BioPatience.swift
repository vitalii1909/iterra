//
//  BioPatience.swift
//  Iterra
//
//  Created by mikhey on 2023-10-25.
//

import Foundation

class BioPatience: BioTask {
    
    var text: String
    
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
