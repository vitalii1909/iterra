//
//  BioView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    
    @ObservedObject var vm: BioVM
    
    private var tasks: [TaskModel] {
       return (taskStore.cleanTimeArray + taskStore.timersArray + taskStore.patienceArray)
    }
    
    private var dict: [Date : [TaskModel]]? {
       return vm.getDict(array: tasks)
    }
    
    var body: some View {
        if let dict = dict {
            List {
                getSections(dict: dict)
            }
            .animation(.spring(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
            .animation(.spring(), value: taskStore.cleanTimeArray.count)
            .listRowSpacing(20)
        } else {
            Text("No clean time")
        }
    }
    
    private func getSections(dict: [Date : [TaskModel]]) -> some View {
        ForEach(dict.map({$0.key}).sorted(by: {$0 < $1}), id: \.timeIntervalSince1970) { key in
            Section() {
                getRows(key: key, dict: dict)
            } header: {
                Text(" \(key.get(.day))/\(key.get(.month))")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func getRows(key: Date, dict: [Date : [TaskModel]]) -> some View {
        let array = dict[key] ?? [TaskModel]()
        return ForEach(array.sorted(by: {$0.deadline < $1.deadline}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
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
            
            if taskModel.type != .cleanTime {
                Text("\(taskModel.deadline.get(.hour)):\(taskModel.deadline.get(.minute))  \(taskModel.deadline.get(.day))/\(taskModel.deadline.get(.month))")
            }
            
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .padding(10)
        .listRowBackground(Color.blue.opacity(0.2))
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
    taskStore.patienceArray = TaskModel.mocArray(type: .patience)

    for i in taskStore.cleanTimeArray {
        i.finished = true
    }
    for i in taskStore.patienceArray {
        i.accepted = true
        i.finished = true
    }
    for i in taskStore.timersArray {
        i.accepted = true
        i.finished = true
    }
    
    return BioView(vm: .init())
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
