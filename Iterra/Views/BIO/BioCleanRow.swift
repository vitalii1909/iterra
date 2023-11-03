//
//  BioCleanRow.swift
//  Iterra
//
//  Created by mikhey on 2023-11-01.
//

import SwiftUI

struct BioCleanRow: View {
    var bioClean: BioClean
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(bioClean.text)
            
            HStack(content: {
                Text("\(bioClean.date.get(.hour)):\(bioClean.date.get(.minute))  \(bioClean.date.get(.day))/\(bioClean.date.get(.month))")
                    .lineLimit(1)
                Spacer()
                
                let date = (bioClean.stopDate ?? Date()).timeIntervalSince(bioClean.startDate)
                Text(date.stringFromTimeInterval().dropLast(4))
                                        .font(.title.bold())
                
                Circle()
                    .foregroundColor(!bioClean.failed ? .green : .red)
                    .frame(width: 40)
            })
        })
    }
}

#Preview {
    BioCleanRow(bioClean: .mocData())
        .padding()
}
