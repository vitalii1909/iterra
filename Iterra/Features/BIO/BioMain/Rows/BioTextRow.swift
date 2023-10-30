//
//  BioTextRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-28.
//

import SwiftUI

struct BioTextRow: View {
    
    var text: String
    
    var body: some View {
        Text(text)
    }
}

#Preview {
    BioTextRow(text: "test text")
}
