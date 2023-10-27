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
            BioView(vm: .init())
                .navigationTitle("BIO")
        })
    }
}

#Preview {
    let taskStore = StoreManager()
//    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .patience)
    
    let userService = UserService()
    userService.user = User(id: "Y7pN9sZVpwgngcEnj0L9", email: "mikhey.work@gmail.com")
    
    return BioNavigationStack()
        .environmentObject(taskStore)
        .environmentObject(userService)
}
