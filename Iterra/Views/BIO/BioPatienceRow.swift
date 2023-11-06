//
//  BioPatienceRow.swift
//  Iterra
//
//  Created by mikhey on 2023-11-01.
//

import SwiftUI

struct BioPatienceRow: View {
    
    var bioPatience: BioPatience
    
    private var bioDateString: String {
        bioPatience.date.getMonthDay()
    }
    
    private var bioTimeString: String {
        bioPatience.date.getHourMisute()
    }
    
    private var waitedString: String {
        String((bioPatience.stopDate ?? Date()).timeIntervalSince(bioPatience.startDate).stringFromTimeInterval().dropLast(4))
    }
    
    var body: some View {
        //        VStack(alignment: .leading, content: {
        //            Text(bioPatience.text)
        //
        //            HStack(content: {
        //                Text("\(bioPatience.date.get(.hour)):\(bioPatience.date.get(.minute))  \(bioPatience.date.get(.day))/\(bioPatience.date.get(.month))")
        //                    .lineLimit(1)
        //                Spacer()
        //
        //                let date = (bioPatience.stopDate ?? Date()).timeIntervalSince(bioPatience.startDate)
        //                Text(date.stringFromTimeInterval().dropLast(4))
        //                                        .font(.title.bold())
        //
        //                Circle()
        //                    .foregroundColor(bioPatience.waited ? .green : .red)
        //                    .frame(width: 40)
        //            })
        //        })
        
        VStack(alignment: .leading, spacing: 12, content: {
            HStack(spacing: 12, content: {
                dateText
                timeText
            })
            HStack(content: {
                mainText
                Spacer()
                waitedText
            })
        })
        .padding(.horizontal, 20)
        .frame(height: 81)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bioPatience.waited ? Color.appBgGreen : .appBgRed)
        .cornerRadius(14)
    }
    
    private var dateText: some View {
        Text(bioDateString)
            .font(.caption1Semibold)
            .foregroundColor(.appBlack)
    }
    
    private var timeText: some View {
        Text(bioTimeString)
            .lineLimit(1)
            .font(.caption1)
            .foregroundColor(.appGray3)
    }
    
    private var mainText: some View {
        Text(bioPatience.text)
            .lineLimit(1)
            .font(.calloutRegular)
            .foregroundStyle(Color.appBlack)
            .multilineTextAlignment(.leading)
    }
    
    private var waitedText: some View {
        Text(waitedString)
            .font(.title2Bold)
            .foregroundStyle(Color.appBlack)
    }
}

#Preview {
    BioPatienceRow(bioPatience: .mocData())
        .padding()
}
