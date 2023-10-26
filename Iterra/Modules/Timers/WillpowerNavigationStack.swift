//
//  WillpowerNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

struct WillpowerNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            WillpowerView(vm: .init())
                .navigationTitle("Willpower")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    InputView(vm: InputVM(type: .willpower))
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
//    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
    return WillpowerNavigationStack()
        .environmentObject(taskStore)
}
