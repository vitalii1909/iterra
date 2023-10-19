//
//  TimersNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-12.
//

import SwiftUI

struct TimersNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            TimersView()
                .navigationTitle("Willpower")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    InputView(vm: InputVM(type: .timer))
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .timer)
    return TimersNavigationStack()
        .environmentObject(taskStore)
}
