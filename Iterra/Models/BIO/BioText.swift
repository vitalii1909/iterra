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
    
    init(id: String? = nil, date: Date, text: String) {
        self.text = text
        super.init(id: id, date: date)
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

extension BioText {
    static func mocDate() -> BioText {
        BioText(id: UUID().uuidString, date: Date(), text: "test text")
    }
}
