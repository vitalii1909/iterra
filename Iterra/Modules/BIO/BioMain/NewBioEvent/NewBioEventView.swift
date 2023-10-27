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
                let bioEvent = BioText(id: UUID().uuidString, startDate: Date(), stopDate: Date(), deadline: Date(), finished: true, text: text)
                
                guard let userId = userService.user?.id else {
                    return
                }
                
                Task {
                    await vm.addNewEvenet(bio: bioEvent, userId: userId)
                    array.append(bioEvent)
                    dismiss()
                }
            }, label: {
                Text("Send")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            })
            .opacity(text.isEmpty ? 0.6 : 1)
            .disabled(text.isEmpty)
        })
        .padding(.horizontal, 20)
        
        
    }
}

#Preview {
    NewBioEventView(array: .constant([BioModel]()))
}
