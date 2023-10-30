//
//  SelectButton.swift
//  Iterra
//
//  Created by mikhey on 2023-10-27.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(bgColor(configuration: configuration))
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
    private func bgColor(configuration: Configuration) -> Color {
        if isEnabled {
            return configuration.isPressed ? .blue.opacity(0.6) : .blue
        } else {
            return Color.blue.opacity(0.2)
        }
    }
}


#Preview {
    Button {
        
    } label: {
        Text("Send")
    }
    .buttonStyle(BlueButton())
    .padding()
}
