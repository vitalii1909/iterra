//
//  Patience2View.swift
//  Iterra
//
//  Created by mikhey on 2023-10-16.
//

import SwiftUI

struct PatienceView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    
    @State var currentDate = Date.now
       let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        
    }
    
    var body: some View {
        
        //FIXME: refactor for props and add vm
        if let dict = getDict() {
            if !dict.map({$0.value}).isEmpty {
                List {
                    ForEach(dict.map({$0.key}).sorted(by: {$0 < $1}), id: \.self) { key in
                        Section() {
                            ForEach((dict[key] ?? [TaskModel]()).sorted(by: {$0.date < $1.date}), id: \.id) { taskModel in
                                taskCell(taskModel: taskModel)
                                    .padding(10)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(10)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            .onDelete { idx in
                                if let row = idx.first, let taskModel = dict[key]?[row] {
                                    withAnimation(.spring()) {
                                        taskStore.patience2Array.removeAll(where: {$0.id == taskModel.id})
                                    }
                                }
                            }
                            
                        } header: {
                            Text(" \(key.get(.day))/\(key.get(.month))")
                                .font(.subheadline.bold())
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .animation(.spring(), value: taskStore.patience2Array.filter({$0.finished == false }).count)
                .animation(.spring(), value: taskStore.patience2Array.count)
                .padding(.horizontal, 20)
                .listStyle(.plain)
                .listRowSpacing(20)
                .onChange(of: taskStore.patience2Array.filter({$0.finished == false}.filter({($0.deadline ?? Date()).timeIntervalSince(Date()) > 0}).count) { newValue in
                    if newValue > 1 {
                        
                    } else {
                        
                    }
                })
            } else {
                Text("No patience2")
            }
        }
    }
    
    func taskCell(taskModel: TaskModel) -> some View {
        VStack(spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                Text(taskModel.deadline ?? Date(), style: .timer)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    if let index = taskStore.patience2Array.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = taskStore.patience2Array[index]
                        task.accepted = false
                        task.finished = true
                        task.stopDate = Date()
                        taskStore.patience2Array[index] = task
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
    }
    
    private func getDict() -> [Date : [TaskModel]]? {
         let array = self.taskStore.patience2Array.filter({$0.finished == false}).sorted(by: {$0.deadline ?? Date() > $1.deadline ?? Date()})
        //FIXME: remove force
        let grouped = array.sliced(by: [.year, .month, .day], for: \.deadline!)
         return grouped
     }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.patience2Array = TaskModel.mocArray(type: .patience2)
    return PatienceView()
        .environmentObject(taskStore)
}
