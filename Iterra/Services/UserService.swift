//
//  UserService.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import Foundation
import FirebaseFirestore

class UserService: ObservableObject {
    
    @Published var user: User?
    
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
        
        self.user = user
        
        return user
    }
    
    private func fetchUsers(withEmail: String, completion: @escaping([User]) -> Void) {
        Firestore.firestore().collection("users").whereField("email", isEqualTo: withEmail)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let users = documents.compactMap({ try? $0.data(as: User.self)})
                
                completion(users)
            }
    }
}
