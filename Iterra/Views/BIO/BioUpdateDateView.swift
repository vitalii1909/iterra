//
//  BioUpdateDateView.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

struct BioUpdateDateView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: BioUpdateDateVM
    
    init(currentBio: BioModel) {
        let vm = BioUpdateDateVM(currentBio: currentBio)
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
                Task {
                    do {
                        try await vm.updateBioDate(userID: publicUserId?.id)
                        dismiss()
                    } catch let error {
                        print("error \(error.localizedDescription)")
                    }
                }
            }, label: {
                Text("Update")
            })
            .buttonStyle(BlueButton())
            //FIXME: compare date and hour only
            .disabled(vm.date.compareMinutes(with: vm.currentBio.date))
            .animation(.smooth, value: vm.date.compareMinutes(with: vm.currentBio.date))
        })
        .padding(.horizontal, 20)
    }
    
    var dateSelector: some View {
        DatePicker("",selection: $vm.date)
            .datePickerStyle(.graphical)
            .labelsHidden()
    }
}

#Preview {
    BioUpdateDateView(currentBio: .init(id: UUID().uuidString, date: Date()))
}
