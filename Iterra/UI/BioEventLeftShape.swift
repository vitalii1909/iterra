//
//  BioEventLeftShape.swift
//  Iterra
//
//  Created by mikhey on 2023-11-03.
//

import SwiftUI

struct BioEventLeftShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: width, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.13422*height), control1: CGPoint(x: 0.38141*width, y: 0.03459*height), control2: CGPoint(x: 0, y: 0.08196*height))
        path.addLine(to: CGPoint(x: 0, y: 0.86025*height))
        path.addCurve(to: CGPoint(x: width, y: 0.99446*height), control1: CGPoint(x: 0, y: 0.9125*height), control2: CGPoint(x: 0.38141*width, y: 0.95988*height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.closeSubpath()
        return path
    }
}

#Preview {
    BioEventLeftShape()
        .frame(width: 10, height: 100)
}
