//
//  InputView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI

struct InputView: View {
    
    @ObservedObject var vm: InputVM
    
    @EnvironmentObject var taskStore: TaskStore
    @Environment(\.dismiss) var dismiss
    
    init(vm: InputVM) {
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(content: {
            
            HStack(content: {
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(5)
                })
            })
            
            if vm.type != .stopwatch {
                dateSelector
            }
            
            Spacer()
            
            VStack(spacing: 32, content: {
                textField
                sendBtn
            })
        })
        .padding(20)
    }
    
    var dateSelector: some View {
        DatePicker("",selection: $vm.selectedDate, in: Date()...)
            .datePickerStyle(.wheel)
            .labelsHidden()
    }
    
    var textField: some View {
        TextField("Idea", text: $vm.text)
            .frame(maxWidth: .infinity)
            .textFieldStyle(.roundedBorder)
    }
    
    var sendBtn: some View {
        Button(action: {
            
            guard !vm.text.isEmpty else {
                return
            }
            
            let task = vm.createTask()
            
            switch task.type {
            case .timer:
                taskStore.timersArray.append(task)
            case .stopwatch:
                taskStore.stopwatchArray.append(task)
            case .patience2:
                taskStore.patience2Array.append(task)
            }

            dismiss()
            
        }, label: {
            Text("Add")
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(10)
                .padding(.bottom, 3)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        })
        .opacity(!vm.text.isEmpty && !(vm.type != .stopwatch && vm.selectedDate < Date()) ? 1 : 0.5)
        .disabled(vm.text.isEmpty || (vm.type != .stopwatch && vm.selectedDate < Date()))
    }
}

#Preview {
    InputView(vm: InputVM(type: .timer))
        .environmentObject(TaskStore())
}
