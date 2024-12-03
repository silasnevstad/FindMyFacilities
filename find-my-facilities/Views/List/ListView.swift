//
//  ListView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    @State private var showingFilter = false

    var body: some View {
        NavigationView {
            List(viewModel.filteredFacilities) { facility in
                FacilityRowView(facility: facility, userLocation: viewModel.userLocation)
                    .onTapGesture {
                        viewModel.selectFacility(facility)
                    }
            }
            .navigationTitle("Facilities")
            .navigationBarItems(
                leading:
                    SearchBar(text: $viewModel.searchQuery),
                trailing:
                    Button(action: {
                        showingFilter = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
            )
            .sheet(isPresented: $viewModel.showReportModal) {
                ReportView()
            }
            .sheet(isPresented: $showingFilter) {
                FilterView()
            }
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
        }
    }
}
