//
//  BioView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    
    private var tasks: [TaskModel] {
        return (taskStore.cleanTimeArray + taskStore.timersArray + taskStore.patienceArray).filter({$0.finished == true}).sorted(by: {$0.date > $1.date})
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(tasks, id: \.id) { task in
                    taskCell(taskModel: task)
                }
            }
        }
    }
    
    func taskCell(taskModel: TaskModel) -> some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(taskModel.text)
                .lineLimit(2)
            
            HStack(content: {
                Spacer()
                
                switch taskModel.type {
                case .willpower:
                    Circle()
                        .foregroundColor(taskModel.accepted ? .green : .red)
                        .frame(width: 40)
                case .patience:
                    let date = (taskModel.stopDate ?? Date()).timeIntervalSince(taskModel.date)
                    Text(date.stringFromTimeInterval().dropLast(4))
                        .font(.title.bold())
                case .cleanTime:
                    HStack(content: {
                        let date = (taskModel.stopDate ?? Date()).timeIntervalSince(taskModel.date)
                        Text(date.stringFromTimeInterval().dropLast(4))
                            .font(.title.bold())
                        
                        Circle()
                            .foregroundColor(taskModel.accepted ? .green : .red)
                            .frame(width: 40)
                    })
                }
            })
            
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
    taskStore.cleanTimeArray = TaskModel.mocArray(type: .patience)
    taskStore.patienceArray = TaskModel.mocArray(type: .cleanTime)
    
    for i in taskStore.cleanTimeArray {
        i.finished = true
    }
    for i in taskStore.patienceArray {
        i.finished = true
    }
    return BioView()
        .environmentObject(taskStore)
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
