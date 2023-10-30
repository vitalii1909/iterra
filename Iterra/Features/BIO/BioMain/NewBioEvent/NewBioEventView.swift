//
//  NewBioEventView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

struct NewBioEventView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userService: UserService
    
    @StateObject var vm: NewBioEventVM = .init()
    
    @Binding var array: [BioModel]
    @State var text = ""
    
    var body: some View {
        VStack(content: {
            
            HStack(content: {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 20)
                })
            })
            
            Spacer()
            TextField("Your event", text: $text)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
            Spacer()
            
            
            Button(action: {
                let bioEvent = BioText(id: UUID().uuidString, date: Date(), finished: true, text: text)
                
                Task {
                    do {
                        try await vm.addNewEvenet(bio: bioEvent, userId: userService.user?.id)
                        array.append(bioEvent)
                        dismiss()
                    } catch let error {
                        print("error \(error)")
                        
                    }
                }
            }, label: {
                Text("Send")
            })
            .buttonStyle(BlueButton())
            .disabled(text.isEmpty)
            .animation(.smooth, value: text.isEmpty)
            .padding(.bottom, 20)
        })
        .padding(.horizontal, 20)
        
        
    }
}

#Preview {
    NewBioEventView(array: .constant([BioModel]()))
}
