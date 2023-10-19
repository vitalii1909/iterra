//
//  StopwatchView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-13.
//

import SwiftUI

struct StopwatchView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    
    var body: some View {

        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(taskStore.stopwatchArray.filter({$0.finished == false}).sorted(by: {$0.date > $1.date}), id: \.id) { taskModel in
                    taskCell(taskModel: taskModel)
                        .padding(10)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
    
    func taskCell(taskModel: TaskModel) -> some View {
        VStack(spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                Text(taskModel.date, style: .timer)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    if let index = taskStore.stopwatchArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = taskStore.stopwatchArray[index]
                        task.accepted = false
                        task.finished = true
                        task.stopDate = Date()
                        taskStore.stopwatchArray[index] = task
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.red)
                })
                .padding(.trailing, 5)
                
            })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.stopwatchArray = TaskModel.mocArray(type: .stopwatch)
    return StopwatchView()
        .environmentObject(taskStore)
}
