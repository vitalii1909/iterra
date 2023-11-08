//
//  HUDVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import SwiftUI

protocol HUDProtocol: ObservableObject {
    var loading: Bool { get set }
    var text: String { get set }
    func addNew() async throws
}

class HUDVM: HUDProtocol {
    @Published var text = ""
    @Published var loading = false
    
    
    @MainActor
    func addNew() async throws {}
}
