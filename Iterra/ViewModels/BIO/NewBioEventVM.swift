//
//  NewBioEventVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

@MainActor
class NewBioEventVM: ObservableObject {
    
    let service: BioRepositoryProtocol
    
    init(service: BioRepositoryProtocol = BioRepository()) {
        self.service = service
    }
    
    func addNewEvenet(bio: BioModel, userId: String?) async throws {
       try await service.addBio(event: bio, userId: userId)
    }
    
}
