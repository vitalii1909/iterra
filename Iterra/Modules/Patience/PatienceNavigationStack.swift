//
//  PatienceNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-16.
//

import SwiftUI

struct PatienceNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            PatienceView(vm: .init())
                .navigationTitle("Patience")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    InputView(vm: InputVM(type: .patience))
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
//    taskStore.patienceArray = TaskModel.mocArray(type: .cleanTime)
    return PatienceNavigationStack()
        .environmentObject(taskStore)
}
