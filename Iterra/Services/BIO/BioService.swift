//
//  BioService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-24.
//

import Foundation
import FirebaseFirestore

protocol BioServiceProtocol {
    func fetchBio(userId: String?) async throws -> [BioModel]?
    func addBio(event: BioModel, userId: String?) async throws
    func updateDate(userId: String?, documentId: String, newDate: Date) async throws
}

class BioService: ObservableObject, BioServiceProtocol {
    
    func fetchBio(userId: String?) async throws -> [BioModel]? {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("bio").getDocuments().documents else {
            throw TestError.dbError
        }
        
        var bioArray = [BioModel]()
        
        for doc in documents {
            if let bioWillpower = try? doc.data(as: BioWillpower.self)  {
                bioArray.append(bioWillpower)
            } else if let bioPatience = try? doc.data(as: BioPatience.self) {
                bioArray.append(bioPatience)
            } else if let bioText = try? doc.data(as: BioText.self) {
                bioArray.append(bioText)
            }else if let bio = try? doc.data(as: BioModel.self)  {
                //handle regular bioModel
                bioArray.append(bio)
            }
        }
        
        if bioArray.isEmpty {
            throw TestError.emptyArray
        }
        
        return bioArray
    }
    
    func addBio(event: BioModel, userId: String?) async throws {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        try Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(from: event)
    }
    
    func updateDate(userId: String?, documentId: String, newDate: Date) async throws {
        
        guard let userId = userId else {
            throw TestError.userId
        }
        
        try await Firestore.firestore().collection("users").document(userId).collection("bio").document(documentId).setData(["date" : newDate], merge: true)
    }
}

enum TestError: Error {
    case userId
    case emptyArray
    case dbError
}
