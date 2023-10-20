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
    
    @State private var localArray = [TaskModel]()
    
    @State var tableView: UITableView?
    
    init(vm: InputVM) {
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            VStack(spacing: 14, content: {
                
                closeBtn
                
                if vm.type != .cleanTime {
                    dateSelector
                }
                
                if vm.type == .cleanTime {
                    Spacer()
                } else {
                    localList
                }
                
                textField
                
                if vm.type == .cleanTime {
                    sendBtn
                } else {
                    newHud(proxy: proxy)
                        .padding(.bottom, 5)
                }
            })
            .padding(.horizontal, 20)
        })
    }
    
    var localList: some View {
        List {
            ForEach(localArray, id: \.id) { taskModel in
                VStack(alignment: .leading, content: {
                    Text(taskModel.text)
                        .font(.title3.bold())
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(taskModel.deadline.get(.hour)):\(taskModel.deadline.get(.minute))  \(taskModel.deadline.get(.day))/\(taskModel.deadline.get(.month))")
                })
                .id(taskModel.id)
                .listRowBackground(Color.blue.opacity(0.2))
            }
            .onDelete(perform: { indexSet in
                localArray.remove(atOffsets: indexSet)
            })
        }
        .listStyle(.plain)
        .cornerRadius(10)
    }
    
    var closeBtn: some View {
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
            case .willpower:
                taskStore.timersArray.append(task)
            case .patience:
                taskStore.patienceArray.append(task)
            case .cleanTime:
                taskStore.cleanTimeArray.append(task)
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
        .opacity(!vm.text.isEmpty && !(vm.type != .cleanTime && vm.selectedDate < Date()) ? 1 : 0.5)
        .disabled(vm.text.isEmpty || (vm.type != .cleanTime && vm.selectedDate < Date()))
    }
    
    
    func newHud(proxy: ScrollViewProxy) -> some View {
        
        return VStack(spacing: 20, content: {
            
            Button(action: {
                guard !vm.text.isEmpty else {
                    return
                }
                
                let task = vm.createTask()
                
                localArray.append(task)
                
                withAnimation {
                    vm.text = ""
                    vm.selectedDate = Date()
                }
                
                DispatchQueue.main.async {
                    if let id = localArray.last?.id {
                        withAnimation {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
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
            .opacity(!vm.text.isEmpty && !(vm.type != .cleanTime && vm.selectedDate < Date()) ? 1 : 0.5)
            .disabled(vm.text.isEmpty || (vm.type != .cleanTime && vm.selectedDate < Date()))
            
            HStack(spacing: 20) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(10)
                        .padding(.bottom, 3)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                })
                
                Button(action: {
                    
                    guard !localArray.isEmpty else {
                        return
                    }
                    
                    switch vm.type {
                    case .willpower:
                        taskStore.timersArray += localArray
                    case .patience:
                        taskStore.patienceArray += localArray
                    case .cleanTime:
                        taskStore.cleanTimeArray += localArray
                    }
                    
                    dismiss()
                }, label: {
                    Text("Apply")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(10)
                        .padding(.bottom, 3)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                })
                .opacity(localArray.count > 0 ? 1 : 0.5)
                .disabled(localArray.count == 0)
            }
        })
        
    }
}

#Preview {
    InputView(vm: InputVM(type: .cleanTime))
        .environmentObject(TaskStore())
}

import UIKit
extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}
