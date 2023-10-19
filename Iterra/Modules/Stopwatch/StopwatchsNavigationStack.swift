//
//  StopwatchsNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-13.
//

import SwiftUI

struct StopwatchsNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            StopwatchView()
                .navigationTitle("Patience")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    InputView(vm: InputVM(type: .stopwatch))
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .stopwatch)
    return StopwatchsNavigationStack()
        .environmentObject(taskStore)
}
