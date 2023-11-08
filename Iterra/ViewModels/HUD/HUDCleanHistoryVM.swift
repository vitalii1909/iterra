//
//  HUDCleanHistoryVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import Foundation

@MainActor
class HUDCleanHistoryVM: HUDVM {
    
    let service: CleanHistoryRepositoryProtocol
    
    private var currentClean: BioClean
    
    init(service: CleanHistoryRepositoryProtocol = CleanHistoryRepository(), currentClean: BioClean) {
        self.service = service
        self.currentClean = currentClean
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
        
        guard  let cleanId = currentClean.id else {
            loading = false
            throw TestError.dbError
        }

        loading = true
        
        let cleanHistory = CleanHistory(date: Date(), text: text)
        
        try await service.add(clean: cleanHistory, cleanId: cleanId, userId: userId)
        
        text = ""
        
        loading = false
    }
}
