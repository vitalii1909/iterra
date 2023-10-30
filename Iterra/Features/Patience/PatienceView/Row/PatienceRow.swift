//
//  PatienceRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

struct PatienceRow: View {
    
    @Binding var storeArray: [BioPatience]
    
    var taskModel: BioPatience
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                Text(taskModel.date, style: .timer)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    if let index = storeArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = storeArray[index]
                        task.accepted = false
//                        task.stopDate = Date()
                        storeArray[index] = task
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.red)
                })
                .buttonStyle(.borderless)
                .padding(.trailing, 5)
            })
            
            Text("\(taskModel.date.get(.hour)):\(taskModel.date.get(.minute))  \(taskModel.date.get(.day))/\(taskModel.date.get(.month))")
        })
        .padding(10)
        .listRowBackground(Color.blue.opacity(0.2))
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    @State var array = [BioPatience]()
    return List {
//        PatienceRow(storeArray: $array, taskModel: array.first ?? .mocData(type: .cleanTime))
        Text("FIX2")
    }
}
