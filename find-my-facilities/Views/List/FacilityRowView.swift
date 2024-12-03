//
//  FacilityRowView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI
import CoreLocation

struct FacilityRowView: View {
    let facility: Facility
    let userLocation: CLLocation?
    
    var distance: Double? {
        guard let userLocation = userLocation else { return nil }
        let facilityLocation = CLLocation(latitude: facility.latitude, longitude: facility.longitude)
        return userLocation.distance(from: facilityLocation)
    }

    var body: some View {
        HStack {
            FacilityIcon(facility: facility)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(facility.name)
                    .font(.headline)
                Text(facility.type.displayName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if let distance = distance {
                    Text("\(String(format: "%.2f km", distance / 1000)) away")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 5)
            Spacer()
            if facility.reportedBy != "Apple" {
                Text("User Reported")
                    .font(.caption)
                    .foregroundColor(.blue)
            } else {
                Text("Apple")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 5)
    }
}
