//
//  CleanTimeDetailsVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import SwiftUI
import FirebaseFirestore

class CleanTimeDetailsVM: HUDProtocol {
    //protocol
    @Published var historyArray = [Date : [CleanHistory]]()
    @Published var text: String = ""
    @Published var hudLoading: Bool = false
    
    @Published var loading: Bool = false
    
    var currentClean: BioClean
    
    private var service: CleanHistoryRepositoryProtocol
    
    init(service: CleanHistoryRepositoryProtocol = CleanHistoryRepository(), currentClean: BioClean) {
        self.service = service
        self.currentClean = currentClean
    }
    
    @MainActor
    func fetch() async throws {
        guard let userId = publicUserId?.id else {
            return
        }
        
        guard let cleanId = currentClean.id else {
            return
        }
        
        loading = true
        
        let array = try await service.fetchHistory(cleanId: cleanId, userId: userId)
        
        if let dict = getDict(array: array) {
            historyArray = dict
        }
        
        loading = false
        
    }
    
    @MainActor
    func addNew() async throws {
        guard !text.isEmpty else {
            throw TestError.dbError
        }
        
        guard let userId = publicUserId?.id else {
            throw TestError.dbError
        }
        
        guard  let cleanId = currentClean.id else {
            throw TestError.dbError
        }

//        loading = true
        
        let newClean = try await service.add(clean: CleanHistory(date: Date(), text: text), cleanId: cleanId, userId: userId)
        
        var array = historyArray.values.flatMap({$0})
        array.append(newClean)
        
        if let dict = getDict(array: array) {
            withAnimation {
                historyArray = dict
            }
        }
        
//        if let key = historyArray.keys.filter({$0.compareDay(with: newClean.date)}).first {
//            historyArray[key] = (historyArray[key] ?? [CleanHistory]()) +  [newClean]
//        } else {
//            historyArray[newClean.date] = [newClean]
//        }

        text = ""
        
//        loading = false
    }
    
    private func getDict(array: [CleanHistory]) -> [Date : [CleanHistory]]? {
         let array = array.sorted(by: {$0.date < $1.date})
         let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
         
         if grouped.map({$0.value}).isEmpty {
             return nil
         } else {
             return grouped
         }
     }
}
