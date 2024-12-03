//
//  CustomTabBarView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

enum Tab {
    case map
    case list
}

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @EnvironmentObject var viewModel: FacilitiesViewModel

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                // Map Tab
                TabBarButton(icon: "map.fill", isSelected: selectedTab == .map) {
                    selectedTab = .map
                }

                Spacer()

                // Report Button
                Button(action: {
                    // Reset relevant ViewModel properties
                    viewModel.showDirectionsModal = false
                    viewModel.selectedFacility = nil
                    viewModel.showFilterModal = false
                    // Toggle the report modal
                    viewModel.showReportModal = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60) // Increased size
                        .foregroundColor(.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .offset(y: -30) // Elevated position

                Spacer()

                // List Tab
                TabBarButton(icon: "list.bullet", isSelected: selectedTab == .list) {
                    selectedTab = .list
                }

                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.top, 1)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
            )
            .padding(.horizontal)
            .padding(.bottom, 15) // Positioned above home indicator
            .frame(height: 80)
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(isSelected ? .blue : .gray)
                .frame(width: 50, height: 50)
        }
    }
}
