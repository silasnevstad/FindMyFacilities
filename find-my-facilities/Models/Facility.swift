//
//  Facility.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Facility: Identifiable, Codable {
    @DocumentID var firestoreID: String?
    
    var id: UUID = UUID()
    
    var name: String
    var type: FacilityType
    var latitude: Double
    var longitude: Double
    var reportedBy: String
    var timestamp: Date
    var notes: String
    var rating: Double?
    var reviews: [Review]?
    
    // Computed property to get CLLocationCoordinate2D
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct Review: Identifiable, Codable {
    @DocumentID var id: String?

    var userId: String
    var comment: String
    var rating: Double
    var timestamp: Date
}
