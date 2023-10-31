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
    
    func fetch() async throws -> [BioTask]? {
        guard let userId = publicUserId?.id else {
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
    
    func add(task: BioTask) async throws -> DocumentReference {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
       return try Firestore.firestore().collection("users").document(userId).collection("willpower").addDocument(from: task)
    }
    
    func moveToBio(task: BioTask, accepted: Bool) async throws {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        guard let documentId = task.id else {
            throw TestError.dbError
        }
        
        task.accepted = accepted
        task.stopDate = Date()
        
        try await Firestore.firestore().collection("users").document(userId).collection("willpower").document(documentId).delete()
        
        try Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(from: task)
    }
    
    func delete(task: BioTask, documentId: String) async throws {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        try await Firestore.firestore().collection("users").document(userId).collection("willpower").document(documentId).delete()
    }
}
