//
//  BioVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

class BioVM: ObservableObject {
    
    var bioService: BioService
    
    init(bioService: BioService = .init()) {
        self.bioService = bioService
    }
    
    func getDict(array: [BioModel]) -> [Date : [BioModel]]? {
        let array = array.filter({$0.finished == true}).sorted(by: {$0.deadline > $1.deadline})
        let grouped = array.sliced(by: [.year, .month, .day], for: \.deadline)
        
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
    
    @MainActor
    func fetchBio(bioArray: Binding<[BioModel]>, userId: String) async {
        
        guard let array = await bioService.fetchBio(userId: userId) else {
            return
        }
        
        bioArray.wrappedValue = array
    }
}
