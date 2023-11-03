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
            if let dict = vm.getDict(array: taskStore.cleanTimeArray) as? [Date : [BioClean]] {
                List {
                    getSections(dict: dict)
                }
//                .animation(.smooth(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
                .animation(.smooth(), value: taskStore.cleanTimeArray.count)
                .listRowSpacing(20)
            } else {
                Text("No clean time")
            }
        }
//        .animation(.smooth(), value: taskStore.cleanTimeArray.filter({$0.finished == false }).count)
        .task {
            guard taskStore.cleanTimeArray.isEmpty else {
                return
            }
            
            Task {
                do {
                    try await vm.fetch(taskArray: $taskStore.cleanTimeArray)
                } catch let error {
                    print("let error \(error)")
                }
            }
        }
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
                Task {
                    do {
                       try await vm.delete(task: taskModel, taskArray: $taskStore.cleanTimeArray)
                    } catch let error {
                        print("error \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func taskCell(taskModel: BioClean) -> some View {
        CleanTimeRow(taskModel: taskModel)
            .environmentObject(vm)
    }
}

#Preview {
    let taskStore = StoreManager()
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .cleanTime)
    return CleanTimeView(vm: .init())
        .environmentObject(taskStore)
}
