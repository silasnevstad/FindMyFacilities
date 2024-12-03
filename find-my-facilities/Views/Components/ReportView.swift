//
//  ReportView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI
import CoreLocation

struct FacilityDetailsSection: View {
    @Binding var facilityName: String
    @Binding var facilityDescription: String
    @Binding var selectedType: FacilityType

    var body: some View {
        GroupBox(label: Text("Details").font(.headline)) {
            VStack(alignment: .leading, spacing: 15) {
                TextField("Name...", text: $facilityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
                
                Text("Select the type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Facility Type Picker with Radio Buttons
                ForEach(FacilityType.allCases) { type in
                    HStack {
                        Image(systemName: selectedType == type ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedType == type ? .blue : .gray)
                            .onTapGesture {
                                selectedType = type
                            }
                        Text(type.displayName)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.vertical, 3)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedType = type
                    }
                }
                
                TextField("Add a description (optional)...", text: $facilityDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
            }
            .padding()
        }
    }
}

struct LocationSection: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    @Binding var reportLocation: CLLocationCoordinate2D?

    var body: some View {
        GroupBox(label: Text("Location").font(.headline)) {
            VStack(alignment: .leading, spacing: 10) {
                if let location = viewModel.userLocation {
                    Text("Current Location:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Latitude: \(location.coordinate.latitude)")
                    Text("Longitude: \(location.coordinate.longitude)")
                    Button(action: {
                        reportLocation = location.coordinate
                    }) {
                        Label("Use Current Location", systemImage: "location.fill")
                            .font(.body)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("Location not available.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}

struct PhotoSection: View {
    @Binding var selectedImage: UIImage?
    @Binding var showingImagePicker: Bool

    var body: some View {
        GroupBox(label: Text("Photo (Optional)").font(.headline)) {
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Add Photo")
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

struct ReportView: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var facilityName: String = ""
    @State private var facilityDescription: String = ""
    @State private var selectedType: FacilityType = .restroom
    @State private var reportLocation: CLLocationCoordinate2D?
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Facility Details Section
                    FacilityDetailsSection(
                        facilityName: $facilityName,
                        facilityDescription: $facilityDescription,
                        selectedType: $selectedType
                    )
                    
                    // Location Section
                    LocationSection(reportLocation: $reportLocation)
                    
                    // Photo Section
                    PhotoSection(
                        selectedImage: $selectedImage,
                        showingImagePicker: $showingImagePicker
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Facility")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        submitReport()
                    }
                    .disabled(facilityName.isEmpty || reportLocation == nil)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
    
    func submitReport() {
        guard let location = reportLocation else { return }
        // Replace with actual user identifier if authentication is implemented
        let reportedBy = "Anonymous"
        viewModel.addFacility(
            name: facilityName,
            notes: facilityDescription,
            type: selectedType,
            coordinate: location,
            reportedBy: reportedBy
        )
        presentationMode.wrappedValue.dismiss()
    }
}
