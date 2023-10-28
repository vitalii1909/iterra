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
    
    @Binding var array: [BioModel]
    var currentBio: BioModel
    
    init(bioService: BioService = BioService(), array: Binding<[BioModel]>, currentBio: BioModel) {
        self.bioService = bioService
        self._array = array
        self.currentBio = currentBio
    }
    
    func updateBioDate(userID: String) async {
        let newDate = date
        
        guard let docId = currentBio.id else {
            return
        }
        
        await bioService.updateDate(userId: userID, documentId: docId, newDate: newDate)
        
        guard let index = array.firstIndex(where: {$0.id == docId}) else {
            return
        }
        
        let bio = currentBio
        bio.date = newDate
        
        array[index] = bio
    }
}
    
