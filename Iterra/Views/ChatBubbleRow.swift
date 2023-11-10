//
//  ChatBubbleRow.swift
//  Iterra
//
//  Created by mikhey on 2023-11-08.
//

import SwiftUI

struct ChatBubbleRow: View {
    
    var text: String
    var date: Date
    
    private var bioDateString: String {
        date.getMonthDay()
    }
    
    private var bioTimeString: String {
        date.getHourMisute()
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5, content: {
            Text(text)
                .font(.calloutRegular)
                .foregroundStyle(Color.appBlack)
                .multilineTextAlignment(.leading)

            timeText
        })
        .padding()
        .background(Color.appGray4)
        .clipShape(ChatBubbleShape(direction: .right))
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
            .foregroundStyle(Color.appBlack)
            .multilineTextAlignment(.trailing)
    }
}

#Preview {
    ChatBubbleRow(text: "test text", date: Date())
}
