//
//  TimersView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

struct TimersView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    
    //MARK: body
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
                                        taskStore.timersArray.removeAll(where: {$0.id == taskModel.id})
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
                .animation(.spring(), value: taskStore.timersArray.filter({$0.finished == false }).count)
                .animation(.spring(), value: taskStore.timersArray.count)
                .padding(.horizontal, 20)
                .listStyle(.plain)
                .listRowSpacing(20)
            } else {
                Text("No timers")
            }
        }
    }
    
    func taskCell(taskModel: TaskModel) -> some View {
        VStack(spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                if taskModel.date.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    Text("Expired")
                        .font(.title.bold())
                } else {
                    Text(taskModel.date, style: .timer)
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button(action: {
                    if let index = taskStore.timersArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = taskStore.timersArray[index]
                        task.accepted = true
                        task.finished = true
                        taskStore.timersArray[index] = task
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
                    if let index = taskStore.timersArray.firstIndex(where: {$0.id == taskModel.id}) {
                        let task = taskStore.timersArray[index]
                        task.accepted = false
                        task.finished = true
                        taskStore.timersArray[index] = task
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
         let array = self.taskStore.timersArray.filter({$0.finished == false}).sorted(by: {$0.date > $1.date})
         let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
         return grouped
     }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .timer)
    return TimersView()
        .environmentObject(taskStore)
}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
