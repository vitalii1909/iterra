//
//  Patience2View.swift
//  Iterra
//
//  Created by mikhey on 2023-10-16.
//

import SwiftUI

struct PatienceView: View {
    
    @EnvironmentObject var taskStore: StoreManager
    
    @ObservedObject var vm: PatienceVM
    
    var body: some View {
        
        VStack {
            if let dict = vm.getDict(array: taskStore.patienceArray) as? [Date : [BioPatience]] {
                List {
                    getSections(dict: dict)
                }
//                .animation(.smooth(), value: taskStore.patienceArray.filter({$0.finished == false }).count)
                .animation(.smooth(), value: taskStore.patienceArray.count)
                .listRowSpacing(20)
            } else {
                Text("No patience")
            }
        }
//        .animation(.smooth(), value: taskStore.patienceArray.filter({$0.finished == false }).count)
        .task {
            guard taskStore.patienceArray.isEmpty else {
                return
            }
            
            Task {
                do {
                    try await vm.fetch(taskArray: $taskStore.patienceArray)
                } catch let error {
                    print("let error \(error)")
                }
            }
        }
    }
    
    private func getSections(dict: [Date : [BioPatience]]) -> some View {
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
    
    private func getRows(key: Date, dict: [Date : [BioPatience]]) -> some View {
        let array = dict[key] ?? [BioPatience]()
        return ForEach(array.sorted(by: {$0.date < $1.date}), id: \.id) { taskModel in
            taskCell(taskModel: taskModel)
        }
        .onDelete { idx in
            if let row = idx.first, let taskModel = dict[key]?.sorted(by: {$0.date < $1.date})[row] {
                withAnimation(.smooth()) {
                    taskStore.patienceArray.removeAll(where: {$0.id == taskModel.id})
                }
            }
        }
    }
    
    private func taskCell(taskModel: BioPatience) -> some View {
        PatienceRow(taskModel: taskModel)
            .environmentObject(vm)
    }
}

#Preview {
    let taskStore = StoreManager()
//    taskStore.patienceArray =
    return PatienceView(vm: PatienceVM())
        .environmentObject(taskStore)
}
