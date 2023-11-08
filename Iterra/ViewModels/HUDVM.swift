//
//  HUDVM.swift
//  Iterra
//
//  Created by mikhey on 2023-11-07.
//

import SwiftUI

protocol HUDProtocol: ObservableObject {
    var hudLoading: Bool { get set }
    var text: String { get set }
    func addNew() async throws
}
