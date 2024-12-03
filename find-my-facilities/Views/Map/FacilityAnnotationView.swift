//
//  FacilityAnnotationView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct FacilityAnnotationView: View {
    let facility: Facility

    var body: some View {
        VStack(spacing: 5) {
            FacilityIcon(facility: facility)
            Text(facility.name)
                .font(.caption2)
                .padding(5)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
        }
    }
    
    private func iconName(for type: FacilityType) -> String {
        switch type {
        case .atm:
            return "dollarsign.circle.fill"
        case .restroom:
            return "toilet.fill"
        case .waterFountain:
            return "drop.fill"
        case .vendingMachine:
            return "cart.fill"
        case .parking:
            return "car.fill"
        case .gasStation:
            return "fuelpump.fill"
        case .foodCourt:
            return "fork.knife"
        case .other:
            return "questionmark.circle"
        }
    }
    
    private func iconColor(for type: FacilityType) -> Color {
        switch type {
        case .atm:
            return .black
        case .restroom:
            return .blue
        case .waterFountain:
            return .yellow
        case .vendingMachine:
            return .purple
        case .parking:
            return .orange
        case .gasStation:
            return .red
        case .foodCourt:
            return .green
        case .other:
            return .gray
        }
    }
}
