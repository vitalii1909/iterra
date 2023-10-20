//
//  WillpowerRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

struct WillpowerRow: View {
    
    @Binding var storeArray: [TaskModel]
    var taskModel: TaskModel
    
    var body: some View {
        VStack(spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                if taskModel.date < Date() {
                    Text("Expired")
                        .font(.title.bold())
                } else {
                    Text(taskModel.date, style: .timer)
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button(action: {
                    if let index = storeArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = storeArray[index]
                        task.accepted = true
                        task.finished = true
                        storeArray[index] = task
                    }
                }, label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.green)
                })
                .padding(.trailing, 10)
                .buttonStyle(.borderless)
                
                Button(action: {
                    if let index = storeArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = storeArray[index]
                        task.accepted = false
                        task.finished = true
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
    @State var array = TaskModel.mocArray(type: .cleanTime)
    return List {
        WillpowerRow(storeArray: $array, taskModel: array.first ?? .mocData(type: .willpower))
    }
}
