//
//  BioWillpoweRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-31.
//

import SwiftUI

struct BioWillpoweRow: View {
    
    var bioWillpower: BioWillpower
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(bioWillpower.text)
            
            HStack(content: {
                Text("\(bioWillpower.date.get(.hour)):\(bioWillpower.date.get(.minute))  \(bioWillpower.date.get(.day))/\(bioWillpower.date.get(.month))")
                    .lineLimit(1)
                Spacer()
                
                Circle()
                    .foregroundColor(bioWillpower.done ? .green : .red)
                    .frame(width: 40)
            })
        })
    }
}

#Preview {
    BioWillpoweRow(bioWillpower: .mocData())
        .padding()
}
