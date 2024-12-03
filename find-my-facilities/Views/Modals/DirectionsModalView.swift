//
//  DirectionsModalView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI
import MapKit

struct DirectionsModalView: View {
    let directionsInfo: DirectionsInfo
    let facility: Facility

    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                FacilityIcon(facility: facility)

                VStack(alignment: .leading) {
                    Text(facility.name)
                        .font(.headline)
                    Text("Distance: \(String(format: "%.2f km", directionsInfo.distance / 1000))")
                        .font(.subheadline)
                    Text("Reported by: \(facility.reportedBy)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [
                        facility.name,
                        "Located at: \(facility.locationCoordinate.latitude), \(facility.locationCoordinate.longitude)"
                    ])
                }
            }

            HStack(spacing: 20) {
                Button(action: {
                    openMaps()
                }) {
                    HStack {
                        Text("Get Directions")
                            .foregroundColor(.white)
                        Image(systemName: "arrow.turn.up.right")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                }

                HStack {
                    Image(systemName: "figure.walk")
                        .foregroundColor(.gray)
                    Text("\(Int(directionsInfo.expectedTravelTime / 60)) mins")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }

            Divider()

            // **Corrected Conditional Binding**
            if !facility.notes.isEmpty {
                Text("Notes: \(facility.notes)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
    }

    func openMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: facility.latitude, longitude: facility.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = facility.name

        // Calculate directions
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}

