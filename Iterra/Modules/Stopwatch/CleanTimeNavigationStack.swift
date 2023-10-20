//
//  CleanTimeNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-13.
//

import SwiftUI

struct CleanTimeNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            CleanTimeView(vm: .init())
                .navigationTitle("Clean")
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
    taskStore.timersArray = TaskModel.mocArray(type: .patience)
    return CleanTimeNavigationStack()
        .environmentObject(taskStore)
}
