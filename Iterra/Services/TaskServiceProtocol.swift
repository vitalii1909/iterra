//
//  TaskServiceProtocol.swift
//  Iterra
//
//  Created by mikhey on 2023-10-29.
//

import FirebaseFirestore

protocol TaskServiceProtocol {
    func fetch() async throws -> [BioTask]?
    func add(task: BioTask) async throws -> DocumentReference
    func moveToBio(task: BioTask, accepted: Bool) async throws
    func delete(task: BioTask, documentId: String) async throws
}
