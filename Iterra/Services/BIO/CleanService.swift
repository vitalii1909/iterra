//
//  CleanService.swift
//  Iterra
//
//  Created by mikhey on 2023-11-01.
//

import Foundation
import FirebaseFirestore

class CleanService: TaskServiceProtocol {
    
    func fetch() async throws -> [BioTask]? {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("clean").getDocuments().documents else {
            throw TestError.dbError
        }
        
        var bioArray = [BioTask]()
        
        for doc in documents {
            if let bio = try? doc.data(as: BioClean.self) {
                bioArray.append(bio)
            }
        }
        
        return bioArray
    }
    
    func add(task: BioTask) async throws -> DocumentReference {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
       return try Firestore.firestore().collection("users").document(userId).collection("clean").addDocument(from: task)
    }
    
    func moveToBio(task: BioTask, accepted: Bool) async throws {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        guard let documentId = task.id else {
            throw TestError.dbError
        }
        
        guard let task = task as? BioClean else {
            throw TestError.dbError
        }
        
        task.failed = accepted
        task.stopDate = Date()
        
        try await Firestore.firestore().collection("users").document(userId).collection("clean").document(documentId).delete()
        
        try Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(from: task)
    }
    
    func delete(task: BioTask, documentId: String) async throws {
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        try await Firestore.firestore().collection("users").document(userId).collection("clean").document(documentId).delete()
    }
}


