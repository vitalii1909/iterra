//
//  HUDView.swift
//  Iterra
//
//  Created by mikhey on 2023-11-04.
//

import SwiftUI
    
//FIXME: make env obj for dif vm
struct HUDView<VM>: View where VM: HUDVM {
    
    @EnvironmentObject var storeManager: StoreManager
    
    @ObservedObject var vm: VM
    
    var body: some View {
        HStack(spacing: 8, content: {
            textField
            
            if vm.loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                sendBtn
            }
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color.appGray2)
    }
    
    private var textField: some View {
        TextField("", text: $vm.text)
            .padding(8)
            .background(Color.appGray4)
            .cornerRadius(10)
    }
    
    private var sendBtn: some View {
        Button(action: {
            Task {
                do {
                    try await vm.addNew()
                } catch let error {
                    print("error \(error)")
                }
            }
        }, label: {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 21, height: 21)
        })
    }
}

#Preview {
    VStack(content: {
        Spacer()
        HUDView(vm: HUDCleanHistoryVM(currentClean: .mocData()))
    })
    .environmentObject(StoreManager())
}
