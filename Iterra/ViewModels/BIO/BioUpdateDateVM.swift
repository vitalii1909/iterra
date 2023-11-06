//
//  BioUpdateDateVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

@MainActor
class BioUpdateDateVM: ObservableObject {
    
    @Published var date = Date()
    
    let bioService: BioService
    
    var currentBio: BioModel
    
    init(bioService: BioService = BioService(), currentBio: BioModel) {
        self.bioService = bioService
        self.currentBio = currentBio
    }
    
    func updateBioDate(userID: String?) async throws {
        let newDate = date
        
        guard let docId = currentBio.id else {
            return
        }
        
        try await bioService.updateDate(userId: userID, documentId: docId, newDate: newDate)
    }
}
    
