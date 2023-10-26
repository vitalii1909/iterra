//
//  BioNavigationStack.swift
//  Iterra
//
//  Created by mikhey on 2023-10-15.
//

import SwiftUI

struct BioNavigationStack: View {
    
    @State var showInput = false
    
    var body: some View {
        NavigationView(content: {
            BioView(vm: .init())
                .navigationTitle("BIO")
                .toolbar {
                    Button(action: {
                        showInput = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .sheet(isPresented: $showInput, content: {
                    NewBioEventView()
                })
        })
    }
}

#Preview {
    let taskStore = TaskStore()
//    taskStore.timersArray = TaskModel.mocArray(type: .willpower)
//    taskStore.cleanTimeArray = TaskModel.mocArray(type: .patience)
    
    let userService = UserService()
    userService.user = User(id: "Y7pN9sZVpwgngcEnj0L9", email: "mikhey.work@gmail.com")
    
    return BioNavigationStack()
        .environmentObject(taskStore)
        .environmentObject(userService)
}
