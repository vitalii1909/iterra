//
//  BioNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioNavigationStack: View {
    var body: some View {
        NavigationView(content: {
            BioView()
                .navigationTitle("BIO")
        })
    }
}

#Preview {
    let taskStore = TaskStore()
    taskStore.timersArray = TaskModel.mocArray(type: .timer)
    taskStore.stopwatchArray = TaskModel.mocArray(type: .stopwatch)
    return BioNavigationStack()
        .environmentObject(taskStore)
}
