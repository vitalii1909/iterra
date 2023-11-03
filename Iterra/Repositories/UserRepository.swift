//
//  UserRepository.swift
//  Iterra
//
//  Created by mikhey on 2023-11-02.
//

import Firebase
import FirebaseFirestore

protocol UserRepositoryProtocol {
    func fetchUser() async throws -> User?
    func signUp(email: String) async throws -> User?
}

class UserRepository: UserRepositoryProtocol {
    
    func fetchUser() async throws -> User? {
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
    
    func signUp(email: String) async throws -> User? {
        guard let document = try? await Firestore.firestore().collection("users").addDocument(data: ["email" : email]) else {
            return nil
        }
        
        let user = User(id: document.documentID, email: email)
        
        publicUserId = user
        
        return user
    }
    
}

