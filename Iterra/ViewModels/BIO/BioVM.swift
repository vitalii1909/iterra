//
//  BioVM.swift
//  Iterra
//
//  Created by mikhey on 2023-10-19.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class BioVM: ObservableObject {
    
    @Published var dict: [Date : [BioModel]] = [Date : [BioModel]]()
    @State var eventText = ""
    
    var cancelBag = CancelBag()
    
    struct SubscriptionID: Hashable {}
    
    var bioService: BioServiceProtocol
    
    init(bioService: BioServiceProtocol = BioService()) {
        self.bioService = bioService
    }
    
    func getDict(array: [BioModel]) -> [Date : [BioModel]]? {
//        let array = array.filter({$0.finished == true}).sorted(by: {$0.date > $1.date})
//        let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
        let array = array.sorted(by: {$0.date > $1.date})
        let grouped = array.sliced(by: [.year, .month, .day], for: \.date)
        
        if grouped.map({$0.value}).isEmpty {
            return nil
        } else {
            return grouped
        }
    }
    
    func fetchBio() async throws {
        
        guard let userId = publicUserId?.id else {
            throw TestError.userId
        }
        
        Firestore.firestore().collection("users").document(userId).collection("bio").addSnapshotListener { [weak self] snap, error in
            
            var bioArray = [BioModel]()
            
            guard let documents = snap?.documents else {
                return
            }
            
            for doc in documents {
                if let bioWillpower = try? doc.data(as: BioWillpower.self)  {
                    bioArray.append(bioWillpower)
                } else if let bioPatience = try? doc.data(as: BioPatience.self) {
                    bioArray.append(bioPatience)
                } else if let bioClean = try? doc.data(as: BioClean.self) {
                    bioArray.append(bioClean)
                } else if let bioText = try? doc.data(as: BioText.self) {
                    bioArray.append(bioText)
                } else if let bio = try? doc.data(as: BioModel.self)  {
                    //handle regular bioModel
                    bioArray.append(bio)
                }
            }
            
            if let dictLocal = self?.getDict(array: bioArray) {
                self?.dict = dictLocal
            }
        }
    }
}
