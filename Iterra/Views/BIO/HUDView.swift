//
//  HUDView.swift
//  Iterra
//
//  Created by mikhey on 2023-11-04.
//

import SwiftUI

struct HUDView: View {
    
    @EnvironmentObject var storeManager: StoreManager
    
    @StateObject var vm: HUDVM
    
    init(vm: HUDVM) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        HStack(spacing: 8, content: {
            textField
            
            if vm.loading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                sendBtn
            }
        })
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color.appGray2)
    }
    
    private var textField: some View {
        TextField("", text: $vm.eventText)
            .padding(8)
            .background(Color.appGray4)
            .cornerRadius(10)
    }
    
    private var sendBtn: some View {
        Button(action: {
            Task {
                do {
                    try await vm.addNewEvenet()
                } catch let error {
                    print("error \(error)")
                }
            }
        }, label: {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 21, height: 21)
        })
    }
}

#Preview {
    VStack(content: {
        Spacer()
        HUDView(vm: .init())
    })
    .environmentObject(StoreManager())
}

@MainActor
class HUDVM: ObservableObject {
    
    @Published var eventText = ""
    
    @Published var loading = false
    
    let service: BioServiceProtocol
    
    init(service: BioServiceProtocol = BioService()) {
        self.service = service
    }
    
    func addNewEvenet() async throws {
        guard !eventText.isEmpty else {
            throw TestError.dbError
        }
        
        guard let userId = publicUserId?.id else {
            throw TestError.dbError
        }

        loading = true
        
        let bioModel = BioText(date: Date(), text: eventText)
        
       try await service.addBio(event: bioModel, userId: userId)
        
        
        eventText = ""
        
        loading = false
    }
    
}
