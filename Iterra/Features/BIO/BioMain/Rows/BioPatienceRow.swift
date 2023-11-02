//
//  BioPatienceRow.swift
//  Iterra
//
//  Created by mikhey on 2023-11-01.
//

import SwiftUI

struct BioPatienceRow: View {
    
    var bioPatience: BioPatience
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(bioPatience.text)
            
            HStack(content: {
                Text("\(bioPatience.date.get(.hour)):\(bioPatience.date.get(.minute))  \(bioPatience.date.get(.day))/\(bioPatience.date.get(.month))")
                    .lineLimit(1)
                Spacer()
                
                let date = (bioPatience.stopDate ?? Date()).timeIntervalSince(bioPatience.startDate)
                Text(date.stringFromTimeInterval().dropLast(4))
                                        .font(.title.bold())
                
                Circle()
                    .foregroundColor(bioPatience.waited ? .green : .red)
                    .frame(width: 40)
            })
        })
    }
}

#Preview {
    BioPatienceRow(bioPatience: .mocData())
        .padding()
}
