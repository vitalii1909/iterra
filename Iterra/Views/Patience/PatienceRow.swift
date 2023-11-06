//
//  PatienceRow.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

struct PatienceRow: View {

    @EnvironmentObject var vm: PatienceVM
    @EnvironmentObject var taskStore: StoreManager
    var taskModel: BioPatience
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(taskModel.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(content: {
                Text(taskModel.date, style: .timer)
                    .font(.title.bold())
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            try await vm.moveToBio(task: taskModel, patienceArray: $taskStore.patienceArray, accepted: false)
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
                .buttonStyle(.borderless)
                .padding(.trailing, 5)
            })
            
            Text("\(taskModel.date.get(.hour)):\(taskModel.date.get(.minute))  \(taskModel.date.get(.day))/\(taskModel.date.get(.month))")
        })
        .padding(10)
        .listRowBackground(Color.blue.opacity(0.2))
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    return List {
        PatienceRow(taskModel: .mocData())
            .environmentObject(StoreManager())
            .environmentObject(PatienceVM())
    }
}
