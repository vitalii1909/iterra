//
//  CleanTimeView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-13.
//

import SwiftUI

struct CleanTimeView: View {
    
    @EnvironmentObject var taskStore: StoreManager
    
    @ObservedObject var vm: CleanTimeVM
    
    var body: some View {
        
        VStack {
            if let dict = vm.getDict(array: taskStore.cleanTimeArray) {
                List {
                    Text("222")
//                    getSections(dict: dict)
                }
                .animation(.spring(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
                .animation(.spring(), value: taskStore.cleanTimeArray.count)
                .listRowSpacing(20)
            } else {
                Text("No clean time")
            }
        }
        .animation(.spring(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
    }
    
    private func getSections(dict: [Date : [BioClean]]) -> some View {
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
    
    private func getRows(key: Date, dict: [Date : [BioClean]]) -> some View {
        let array = dict[key] ?? [BioClean]()
        return ForEach(array.sorted(by: {$0.date < $1.date}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
        }
        .onDelete { idx in
            if let row = idx.first, let taskModel = dict[key]?.sorted(by: {$0.date < $1.date})[row] {
                withAnimation(.spring()) {
                    taskStore.cleanTimeArray.removeAll(where: {$0.id == taskModel.id})
                }
            }
        }
    }
    
    private func taskCell(taskModel: BioClean) -> some View {
        CleanTimeRow(storeArray: $taskStore.cleanTimeArray, taskModel: taskModel)
    }
}

#Preview {
    let taskStore = StoreManager()
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
    return CleanTimeView(vm: .init())
        .environmentObject(taskStore)
}
