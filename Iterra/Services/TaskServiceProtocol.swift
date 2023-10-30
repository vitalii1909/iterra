//
//  TaskServiceProtocol.swift
//  Iterra
//
//  Created by mikhey on 2023-10-29.
//

import FirebaseFirestore

protocol TaskServiceProtocol {
    func fetch(userId: String?) async throws -> [BioTask]?
    func add(task: BioTask, userId: String?) async throws -> DocumentReference
    func moveToBio(task: BioTask, userId: String?) async throws
    func delete(task: BioTask, documentId: String, userId: String?) async throws
}
