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
        "\(bioWillpower.date.get(.day)).\(bioWillpower.date.get(.month))"
    }
    
    private var bioTimeString: String {
        "\(bioWillpower.date.get(.hour)):\(bioWillpower.date.get(.minute))"
    }
    
    var body: some View {
        ZStack(alignment: .leading, content: {
            VStack(spacing: 12, content: {
                HStack(spacing: 12, content: {
                    dateText
                    timeText
                })
                mainText
            })
            .padding(.leading, 20)
            .frame(height: 81)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bioWillpower.done ? Color.lightGreen : .myLightOrange)
            .cornerRadius(14)
            
            leftShape
        })
        
    }
    
    private var dateText: some View {
        Text(bioDateString)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11))
    }
    
    private var timeText: some View {
        Text(bioTimeString)
            .lineLimit(1)
            .font(Font.custom("SF Pro Text", size: 12))
            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.11).opacity(0.6))
    }
    
    private var mainText: some View {
        Text(bioWillpower.text)
            .lineLimit(1)
            .font(Font.custom("SF Pro Text", size: 16))
    }
    
    private var leftShape: some View {
        BioEventLeftShape()
            .frame(width: 5, height: 74.59593)
            .foregroundStyle(bioWillpower.done ? .myGreen : .myOrange)
    }
}

#Preview {
    BioWillpoweRow(bioWillpower: .mocData())
        .padding()
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
