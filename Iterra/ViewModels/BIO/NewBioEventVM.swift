//
//  NewBioEventVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-26.
//

import SwiftUI

@MainActor
class NewBioEventVM: ObservableObject {
    
    let service: BioServiceProtocol
    
    init(service: BioServiceProtocol = BioService()) {
        self.service = service
    }
    
    func addNewEvenet(array: Binding<[BioModel]>, bio: BioModel, userId: String?) async throws {
       let docRef = try await service.addBio(event: bio, userId: userId)
        
        guard let task = bio as? BioText else {
            throw TestError.dbError
        }
        
        task.id = docRef.documentID
        array.wrappedValue.append(task)
    }
    
}
