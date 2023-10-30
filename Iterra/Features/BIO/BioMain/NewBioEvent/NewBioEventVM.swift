//
//  NewBioEventVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import Foundation

class NewBioEventVM: ObservableObject {
    
    func addNewEvenet(bioService: BioService = BioService(), bio: BioModel, userId: String?) async throws {
        try await bioService.addBio(event: bio, userId: userId)
    }
    
}
