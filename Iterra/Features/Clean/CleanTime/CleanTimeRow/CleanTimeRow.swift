//
//  CleanTimeRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

struct CleanTimeRow: View {
    
    @Binding var storeArray: [BioClean]
    
    var taskModel: BioClean
    
    var body: some View {
        VStack(spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                Text(taskModel.startDate, style: .timer)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    if let index = storeArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = storeArray[index]
//                        task.accepted = false
                        task.stopDate = Date()
                        storeArray[index] = task
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.red)
                })
                .padding(.trailing, 5)
                .buttonStyle(.borderless)
            })
        })
        .padding(10)
        .listRowBackground(Color.blue.opacity(0.2))
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    @State var array = [BioClean]()
    return List {
//        CleanTimeRow(storeArray: $array, taskModel: array.first ?? <#default value#>)
        Text("FIX")
    }
}
