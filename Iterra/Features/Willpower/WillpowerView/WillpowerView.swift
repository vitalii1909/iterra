//
//  WillpowerView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

struct WillpowerView: View {
    
    @EnvironmentObject var taskStore: StoreManager
    @ObservedObject var vm: WillpowerVM
    
    var body: some View {
        
        VStack {
            if let dict = vm.getDict(array: taskStore.timersArray) as? [Date : [BioWillpower]] {
                List {
                    getSections(dict: dict)
                }
                .animation(.smooth(), value: taskStore.timersArray.filter({$0.finished == false }).count)
                .animation(.smooth(), value: taskStore.timersArray.count)
                .listRowSpacing(20)
            } else {
                Text("No willpower")
            }
        }
        .animation(.smooth(), value: taskStore.timersArray.filter({$0.finished == false }).count)
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
        return ForEach(array.sorted(by: {$0.date < $1.date}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
        }
        .onDelete { idx in
            if let row = idx.first, let taskModel = dict[key]?.sorted(by: {$0.date < $1.date})[row] {
                withAnimation(.smooth()) {
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
    let taskStore = StoreManager()
    taskStore.timersArray = BioWillpower.mocArray()
    return WillpowerView(vm: .init())
        .environmentObject(taskStore)
}
