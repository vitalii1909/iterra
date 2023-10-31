//
//  WillpowerRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

struct WillpowerRow: View {
    
    @EnvironmentObject var vm: WillpowerVM
    @EnvironmentObject var taskStore: StoreManager
    @Binding var storeArray: [BioWillpower]
    var taskModel: BioWillpower
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                if taskModel.date < Date() {
                    Text("Expired")
                        .font(.title.bold())
                } else {
                    Text(taskModel.date, style: .timer)
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await vm.moveToBio(task: taskModel, timersArray: $taskStore.timersArray, accepted: true)
                        } catch let error {
                            print("error \(error.localizedDescription)")
                        }
                    }

//                    if let index = storeArray.firstIndex(where: {$0.id == taskModel.id}) {
//                        let task = storeArray[index]
//                        task.accepted = true
//                        task.stopDate = Date()
//                        storeArray[index] = task
//                    }
                }, label: {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.green)
                })
                .padding(.trailing, 10)
                .buttonStyle(.borderless)
                
                Button(action: {
                    Task {
                        do {
                            try await vm.moveToBio(task: taskModel, timersArray: $taskStore.timersArray, accepted: false)
                        } catch let error {
                            print("error \(error.localizedDescription)")
                        }
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
            
            Text("\(taskModel.date.get(.hour)):\(taskModel.date.get(.minute))  \(taskModel.date.get(.day))/\(taskModel.date.get(.month))")
        })
        .padding(10)
        .listRowBackground(Color.blue.opacity(0.2))
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    @State var array = [BioWillpower]()
    return List {
        WillpowerRow(storeArray: .constant([BioWillpower]()), taskModel: .mocData())
            .environmentObject(WillpowerVM())
            .environmentObject(StoreManager())
    }
}
