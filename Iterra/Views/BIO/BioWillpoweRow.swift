//
//  BioWillpoweRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-31.
//

import SwiftUI

struct BioWillpoweRow: View {
    
    var bioWillpower: BioWillpower
    
    private var bioDateString: String {
        bioWillpower.date.getMonthDay()
    }
    
    private var bioTimeString: String {
        bioWillpower.date.getHourMisute()
    }
    
    var body: some View {
        ZStack(alignment: .leading, content: {
            VStack(alignment: .leading, spacing: 12, content: {
                HStack(spacing: 12, content: {
                    dateText
                    timeText
                })
                mainText
            })
            .padding(.horizontal, 20)
            .frame(height: 81)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bioWillpower.done ? Color.appBgGreen : .appBgRed)
            .cornerRadius(14)
            
            leftShape
        })
        
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
        Text(bioWillpower.text)
            .lineLimit(1)
            .font(.calloutRegular)
            .foregroundStyle(Color.appBlack)
            .multilineTextAlignment(.leading)
    }
    
    private var leftShape: some View {
        BioEventLeftShape()
            .frame(width: 5, height: 74.59593)
            .foregroundStyle(bioWillpower.done ? .appGreen : Color.appOrange)
    }
}

#Preview {
    BioWillpoweRow(bioWillpower: .mocData(done: false))
        .padding()
}

extension Date {
    func getMonthDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        let monthString = dateFormatter.string(from: self)
        return monthString
    }
    
    func getHourMisute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let monthString = dateFormatter.string(from: self)
        return monthString
    }
}
