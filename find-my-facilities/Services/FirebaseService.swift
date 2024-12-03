//
//  FirebaseService.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestore
import Combine

class FirebaseService: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var facilities: [Facility] = []
    private var listener: ListenerRegistration?
    
    init() {
        fetchFacilities()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchFacilities() {
        listener = db.collection("facilities")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching facilities: \(error)")
                    return
                }
                self.facilities = querySnapshot?.documents.compactMap { document in
                    do {
                        var facility = try document.data(as: Facility.self)
                        facility.firestoreID = document.documentID // Assign Firestore document ID
                        return facility
                    } catch {
                        print("Error decoding facility: \(error)")
                        return nil
                    }
                } ?? []
            }
    }
    
    func addFacility(_ facility: Facility) {
        do {
            _ = try db.collection("facilities").addDocument(from: facility)
        } catch {
            print("Error adding facility: \(error)")
        }
    }
}
