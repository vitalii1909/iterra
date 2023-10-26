//
//  User.swift
//  Iterra
//
//  Created by mikhey on 2023-10-23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let email: String
}

extension User {
    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id
    }
}
