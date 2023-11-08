//
//  HUDBioVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import Foundation

@MainActor
class HUDBioVM: HUDVM {
    let service: BioRepositoryProtocol
    
    init(service: BioRepositoryProtocol = BioRepository()) {
        self.service = service
    }
    
    override func addNew() async throws {
        guard !text.isEmpty else {
            loading = false
            throw TestError.dbError
        }
        
        guard let userId = publicUserId?.id else {
            loading = false
            throw TestError.dbError
        }

        loading = true
        
        let bioModel = BioText(date: Date(), text: text)
        
       try await service.addBio(event: bioModel, userId: userId)
        
        text = ""
        
        loading = false
    }
}
