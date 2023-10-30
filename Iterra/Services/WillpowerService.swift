//
//  WillpowerService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class WillpowerService: TaskServiceProtocol {
    
    func fetch(userId: String?) async throws -> [BioTask]? {
        guard let userId = userId else {
            throw TestError.userId
        }
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("willpower").getDocuments().documents else {
            throw TestError.dbError
        }
        
        var bioArray = [BioTask]()
        
        for doc in documents {
            if let bio = try? doc.data(as: BioWillpower.self) {
                bioArray.append(bio)
            }
        }
        
        return bioArray
    }
    
    func add(task: BioTask, userId: String?) async throws -> DocumentReference {
        guard let userId = userId else {
            throw TestError.userId
        }
        
       return try Firestore.firestore().collection("users").document(userId).collection("willpower").addDocument(from: task)
    }
    
    func moveToBio(task: BioTask, userId: String?) async throws {
        guard let userId = userId else {
            throw TestError.userId
        }
        
        guard let documentId = task.id else {
            return
        }
        
        try await Firestore.firestore().collection("users").document(userId).collection("willpower").document(documentId).delete()
        
//        let encoded = try Firestore.Encoder().encode(task)
        
        try Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(from: task)
//        try await  Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(data: encoded)
    }
    
    func delete(task: BioTask, documentId: String, userId: String?) async throws {
        guard let userId = userId else {
            throw TestError.userId
        }
        
        try await Firestore.firestore().collection("users").document(userId).collection("willpower").document(documentId).delete()
    }
    
    
}
