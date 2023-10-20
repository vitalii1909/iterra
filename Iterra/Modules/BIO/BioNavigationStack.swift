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
    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
    taskStore.cleanTimeArray = TaskModel.mocArray(type: .patience)
    return BioNavigationStack()
        .environmentObject(taskStore)
}