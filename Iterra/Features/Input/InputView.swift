//
//  InputView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-11.
//

import SwiftUI

struct InputView: View {
    
    @ObservedObject var vm: InputVM
    
    @EnvironmentObject private var taskStore: StoreManager
    @EnvironmentObject private var userService: UserService
    @Environment(\.dismiss) var dismiss
    
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
            ForEach(vm.localArray, id: \.id) { taskModel in
                VStack(alignment: .leading, content: {
                    //                    Text(taskModel.text)
                    //                        .font(.title3.bold())
                    //                        .lineLimit(1)
                    //                        .multilineTextAlignment(.leading)
                    
                    Text("\(taskModel.date.get(.hour)):\(taskModel.date.get(.minute))  \(taskModel.date.get(.day))/\(taskModel.date.get(.month))")
                })
                .id(taskModel.id)
                .listRowBackground(Color.blue.opacity(0.2))
            }
            .onDelete(perform: { indexSet in
                vm.localArray.remove(atOffsets: indexSet)
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
            
            
            
//            let task = vm.createTask()
//            
//            switch task {
//            case let bio as BioWillpower:
//                taskStore.timersArray.append(bio)
//            case let bio as BioPatience:
//                taskStore.patienceArray.append(bio)
//            case let bio as BioClean:
//                taskStore.cleanTimeArray.append(bio)
//            default:
//                break
//            }
            
//            dismiss()
            
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
                
                vm.localArray.append(task)
                
                withAnimation {
                    vm.text = ""
                    vm.selectedDate = Date()
                }
                
                DispatchQueue.main.async {
                    if let id = vm.localArray.last?.id {
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
                    
                    Task {
                        do {
                            switch vm.type {
                            case .willpower:
                                try await vm.addWillpower(array: $taskStore.timersArray, userId: publicUserId?.id)
                                dismiss()
                            default:
                                break
                            }
                        } catch let error {
                            print("error \(error.localizedDescription)")
                        }
                    }
                    
                    
//                    guard !localArray.isEmpty else {
//                        return
//                    }
//                    
//                    switch localArray {
//                    case let local as [BioWillpower]:
//                        taskStore.timersArray += local
//                    case let local as [BioPatience]:
//                        taskStore.patienceArray += local
//                    case let local as [BioClean]:
//                        taskStore.cleanTimeArray += local
//                    default:
//                        break
//                    }
//                    
//                    dismiss()
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
                .opacity(vm.localArray.count > 0 ? 1 : 0.5)
                .disabled(vm.localArray.count == 0)
            }
        })
        
    }
}

#Preview {
    InputView(vm: InputVM(type: .willpower))
        .environmentObject(StoreManager())
        .environmentObject(UserService())
}

import UIKit
extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}
