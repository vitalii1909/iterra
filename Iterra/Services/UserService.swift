//
//  UserService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import Foundation
import FirebaseFirestore

//FIXME: need delete after auth
var publicUserId: User?

class UserService: ObservableObject {
    
    @MainActor
    func fetchUser() async -> User? {
        
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            return nil
        }
        
        guard let document = try? await Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments().documents.first else {
            
            return nil
        }
        
        guard let user = try? document.data(as: User.self) else {
            return nil
        }
        
        publicUserId = user
        
        return user
    }
    
    func signUpUser(email: String) async -> User? {
        guard let document = try? await Firestore.firestore().collection("users").addDocument(data: ["email" : email]) else {
            return nil
        }
        
        let user = User(id: document.documentID, email: email)
        
        publicUserId = user
        
        return user
    }
}
