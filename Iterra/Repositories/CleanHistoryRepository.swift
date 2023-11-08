//
//  CleanHistoryRepository.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import Foundation
import FirebaseFirestore

protocol CleanHistoryRepositoryProtocol {
    func fetchHistory(cleanId: String, userId: String?) async throws -> [CleanHistory]
    func add(clean: CleanHistory, cleanId: String, userId: String?) async throws
//    func updateDate(userId: String?, documentId: String, newDate: Date) async throws
}

class CleanHistoryRepository: ObservableObject, CleanHistoryRepositoryProtocol {
    
    func fetchHistory(cleanId: String, userId: String?) async throws -> [CleanHistory] {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("clean").document(cleanId).collection("history").getDocuments().documents else {
            throw TestError.dbError
        }
        
        var cleanHistoryArray = [CleanHistory]()
        
        documents.forEach { doc in
            if let cleanHistory = try? doc.data(as: CleanHistory.self) {
                cleanHistoryArray.append(cleanHistory)
            }
        }
    
        return cleanHistoryArray
    }
    
    func add(clean: CleanHistory, cleanId: String, userId: String?) async throws {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        try Firestore.firestore().collection("users").document(userId).collection("clean").document(cleanId).collection("history").addDocument(from: clean)
    }
    
//    func updateDate(userId: String?, documentId: String, newDate: Date) async throws {
//        
//        guard let userId = userId else {
//            throw TestError.userId
//        }
//        
//        try await Firestore.firestore().collection("users").document(userId).collection("bio").document(documentId).setData(["date" : newDate], merge: true)
//    }
}
