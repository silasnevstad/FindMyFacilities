//
//  CustomTabBarOverlay.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct CustomTabBarOverlay: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showDirectionsModal = false
                    viewModel.selectedFacility = nil
                    viewModel.showReportModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30)
                Spacer()
            }
        }
    }
}
