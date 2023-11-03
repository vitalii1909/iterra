//
//  UserFirebaseRepository.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import Foundation
import FirebaseFirestore

//FIXME: need delete after auth
var publicUserId: User?

@MainActor
class UserFirebaseManager: ObservableObject {
    
    @Published var user: User?
    
    let service: UserRepositoryProtocol
    
    init(service: UserRepositoryProtocol = UserRepository()) {
        self.service = service
    }
    
    func fetchUser() async throws -> User? {
        //FIXME: add throw errors
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            return nil
        }
        
        guard let document = try? await Firestore.firestore().collection("users").whereField("email", isEqualTo: email).getDocuments().documents.first else {
            
            return nil
        }
        
        guard let user = try? document.data(as: User.self) else {
            return nil
        }
        
        //FIXME: delete after signUp
        publicUserId = user
        
        return user
    }
    
    func signUpUser(email: String) async throws -> User? {
        
        guard let document = try? await Firestore.firestore().collection("users").addDocument(data: ["email" : email]) else {
            throw TestError.dbError
        }
        
        let user = User(id: document.documentID, email: email)
        
        publicUserId = user
        
        return user
    }
}
