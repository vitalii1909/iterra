//
//  BioService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-24.
//

import Foundation
import FirebaseFirestore

protocol BioServiceProtocol {
    func fetchBio(userId: String) async -> [BioModel]?
    func addBio(event: BioModel, userId: String) async
    func updateDate(userId: String, documentId: String, newDate: Date) async
}

class BioService: ObservableObject, BioServiceProtocol {
    
    func fetchBio(userId: String) async -> [BioModel]? {
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("bio").getDocuments().documents else {
            return nil
        }
        
        var bioArray = [BioModel]()
        
        for doc in documents {
            if let bio = try? doc.data(as: BioText.self) {
                bioArray.append(bio)
                //handle regular bioModel
            } else if let bio = try? doc.data(as: BioModel.self)  {
                bioArray.append(bio)
            }
        }
        
        return bioArray
    }
    
    func addBio(event: BioModel, userId: String) async {
        do {
            try Firestore.firestore().collection("users").document(userId).collection("bio").addDocument(from: event)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    func updateDate(userId: String, documentId: String, newDate: Date) async {
        do {
            try await Firestore.firestore().collection("users").document(userId).collection("bio").document(documentId).setData(["date" : newDate], merge: true)
            
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
}
