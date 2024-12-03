//
//  FacilityIcon.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct FacilityIcon: View {
    let facility: Facility

    var body: some View {
        Image(systemName: iconName(for: facility.type))
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(iconColor(for: facility.type))
            .padding(10)
            .background(backgroundColor(for: facility.type))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(iconColor(for: facility.type), lineWidth: 2)
            )
    }

    private func iconName(for type: FacilityType) -> String {
        switch type {
        case .atm:
            return "creditcard.fill"
        case .restroom:
            return "toilet.fill"
        case .waterFountain:
            return "drop.fill"
        case .vendingMachine:
            return "bag.fill"
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
    
    private func backgroundColor(for type: FacilityType) -> Color {
        return Color.white.opacity(0.9)
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
