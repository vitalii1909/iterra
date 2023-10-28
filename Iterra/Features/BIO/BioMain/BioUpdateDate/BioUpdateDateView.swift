//
//  BioUpdateDateView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

struct BioUpdateDateView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userService: UserService
    @StateObject var vm: BioUpdateDateVM
    
    init(array: Binding<[BioModel]>, currentBio: BioModel) {
        let vm = BioUpdateDateVM(array: array, currentBio: currentBio)
        vm.date = currentBio.date
        self._vm = StateObject(wrappedValue: vm)
    }
    
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
            
            dateSelector
            
            Spacer()
            
            Button(action: {
                guard let userID = userService.user?.id else {
                    return
                }
                Task {
                    await vm.updateBioDate(userID: userID)
                    dismiss()
                }
            }, label: {
                Text("Update")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            })
        })
        .padding(.horizontal, 20)
    }
    
    var dateSelector: some View {
        DatePicker("",selection: $vm.date)
            .datePickerStyle(.wheel)
            .labelsHidden()
    }
}

#Preview {
    BioUpdateDateView(array: .constant([BioModel]()), currentBio: .init(id: UUID().uuidString, date: Date()))
        .environmentObject(UserService())
}
