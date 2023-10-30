//
//  BioVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI

@MainActor
class BioVM: ObservableObject {
    
    var bioService: BioServiceProtocol
    
    init(bioService: BioServiceProtocol = BioService()) {
        self.bioService = bioService
    }
    
    func getDict(array: [BioModel]) -> [Date : [BioModel]]? {
//        let array = array.filter({$0.finished == true}).sorted(by: {$0.date > $1.date})
//        let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
        let array = array.sorted(by: {$0.date > $1.date})
        let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
        
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
    
    func fetchBio(bioArray: Binding<[BioModel]>, userId: String?) async throws {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        do {
            guard let array = try await bioService.fetchBio(userId: userId) else {
                return
            }
            bioArray.wrappedValue = array
        } catch let error {
            throw error
        }
        
    }
}
