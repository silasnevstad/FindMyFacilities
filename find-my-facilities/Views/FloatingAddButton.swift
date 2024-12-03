//
//  FloatingAddButton.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct FloatingAddButton: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    @State private var showingReport = false

    var body: some View {
        Button(action: {
            viewModel.showDirectionsModal = false
            viewModel.selectedFacility = nil
            showingReport = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .sheet(isPresented: $showingReport) {
            ReportView()
        }
    }
}

struct FloatingAddButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAddButton()
            .environmentObject(FacilitiesViewModel())
    }
}


