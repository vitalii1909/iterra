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
            PatienceView()
                .navigationTitle("Patience2")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    InputView(vm: InputVM(type: .patience2))
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .patience2)
    return PatienceNavigationStack()
        .environmentObject(taskStore)
}
