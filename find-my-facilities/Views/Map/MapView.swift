//
//  MapView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    
    @State private var region: MKCoordinateRegion
    
    init() {
        // Initialize the region with a default location
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: viewModel.filteredFacilities) { facility in
                MapAnnotation(coordinate: facility.locationCoordinate) {
                    FacilityAnnotationView(facility: facility)
                        .onTapGesture {
                            viewModel.selectedFacility = facility
                            viewModel.fetchDirectionsForSelectedFacility()
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Center the map on the user's location if available
                if let userLocation = viewModel.userLocation {
                    region = MKCoordinateRegion(
                        center: userLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                }
            }
            .onChange(of: viewModel.userLocation) { newLocation in
                guard let newLocation = newLocation else { return }
            }
            
            // Optional: Add a button to center the map on the user's location
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if let userLocation = viewModel.userLocation {
                            withAnimation {
                                region = MKCoordinateRegion(
                                    center: userLocation.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                )
                            }
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding()
                }
            }
        }
        // Modals
        .sheet(isPresented: $viewModel.showDirectionsModal) {
            if let directions = viewModel.directionsInfo,
               let facility = viewModel.selectedFacility {
                DirectionsModalView(directionsInfo: directions, facility: facility)
                    .presentationDetents([.fraction(0.33), .fraction(0.5), .large])
            } else {
                ProgressView("Loading directions...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $viewModel.showFilterModal) {
            FilterView()
        }
        .sheet(isPresented: $viewModel.showReportModal) {
            ReportView()
        }
    }
}
