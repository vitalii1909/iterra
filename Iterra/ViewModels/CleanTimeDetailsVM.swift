//
//  CleanTimeDetailsVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class CleanTimeDetailsVM: ObservableObject {
    
    @Published var historyArray = [Date : [CleanHistory]]()
    
    private var service: CleanHistoryRepositoryProtocol
    
    var currentClean: BioClean
    
    init(service: CleanHistoryRepositoryProtocol = CleanHistoryRepository(), currentClean: BioClean) {
        self.service = service
        self.currentClean = currentClean
    }
    
    func fetch() async throws {
        guard let userId = publicUserId?.id else {
            return
        }
        
        guard let cleanId = currentClean.id else {
            return
        }
        
         let array = try await service.fetchHistory(cleanId: cleanId, userId: userId)
        
        if let dict = getDict(array: array) {
            historyArray = dict
        }
        
    }
    
    private func getDict(array: [CleanHistory]) -> [Date : [CleanHistory]]? {
         let array = array.sorted(by: {$0.date > $1.date})
         let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
         
         if grouped.map({$0.value}).isEmpty {
             return nil
         } else {
             return grouped
         }
     }
}
