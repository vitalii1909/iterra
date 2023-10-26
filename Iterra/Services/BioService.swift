//
//  BioService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-24.
//

import Foundation
import FirebaseFirestore

class BioService: ObservableObject {
    
    func fetchBio(userId: String) async -> [BioModel]? {
        
        guard let documents = try? await Firestore.firestore().collection("users").document(userId).collection("bio").getDocuments().documents else {
            return nil
        }
        
        var bioArray = [BioModel]()
        
        for doc in documents {
            if let bio = try? doc.data(as: BioText.self) {
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
    
}

//extension QueryDocumentSnapshot {
//
//    func prepareForDecoding() -> [String: Any] {
//        var data = self.data()
//        data["documentId"] = self.documentID
//
//        return data
//    }
//}
