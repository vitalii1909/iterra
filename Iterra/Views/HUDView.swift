//
//  HUDView.swift
//  Iterra
//
//  Created by mikhey on 2023-11-04.
//

import SwiftUI
    
struct HUDView<Provider>: View where Provider: HUDProtocol {
    
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var vm: Provider
    
    var body: some View {
        HStack(spacing: 8, content: {
            textField
            
            if vm.hudLoading {
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
            Image(systemName: "arrow.up")
                .foregroundColor(.appWhite)
                .padding(5)
                .background(Color.blue)
                .clipShape(Circle())
        })
    }
}

#Preview {
    VStack(content: {
        HUDView<CleanTimeDetailsVM>()
            .environmentObject(CleanTimeDetailsVM(currentClean: .mocData()))
    })
    .frame(maxHeight: .infinity, alignment: .bottom)
    .environmentObject(StoreManager())
}
