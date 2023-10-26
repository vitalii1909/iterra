//
//  WillpowerView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

struct WillpowerView: View {
    
    @EnvironmentObject var taskStore: TaskStore
    @ObservedObject var vm: WillpowerVM
    
    var body: some View {
        
        VStack {
            if let dict = vm.getDict(array: taskStore.timersArray) as? [Date : [BioWillpower]] {
                List {
                    getSections(dict: dict)
                }
                .animation(.spring(), value: taskStore.timersArray.filter({$0.finished == false }).count)
                .animation(.spring(), value: taskStore.timersArray.count)
                .listRowSpacing(20)
            } else {
                Text("No willpower")
            }
        }
        .animation(.spring(), value: taskStore.timersArray.filter({$0.finished == false }).count)
    }
    
    private func getSections(dict: [Date : [BioWillpower]]) -> some View {
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
    
    private func getRows(key: Date, dict: [Date : [BioWillpower]]) -> some View {
        let array = dict[key] ?? [BioWillpower]()
        return ForEach(array.sorted(by: {$0.deadline < $1.deadline}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
        }
        .onDelete { idx in
            if let row = idx.first, let taskModel = dict[key]?.sorted(by: {$0.deadline < $1.deadline})[row] {
                withAnimation(.spring()) {
                    taskStore.timersArray.removeAll(where: {$0.id == taskModel.id})
                }
            }
        }
    }
    
    private func taskCell(taskModel: BioWillpower) -> some View {
        WillpowerRow(storeArray: $taskStore.timersArray, taskModel: taskModel)
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = BioWillpower.mocArray()
    return WillpowerView(vm: .init())
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
