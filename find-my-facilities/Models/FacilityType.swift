//
//  FacilityType.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import Foundation

enum FacilityType: String, CaseIterable, Identifiable, Codable {
    case restroom
    case waterFountain
    case vendingMachine
    case atm
    case parking
    case gasStation
    case foodCourt
    case other

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .atm:
            return "ATM"
        case .restroom:
            return "Restroom"
        case .waterFountain:
            return "Water Fountain"
        case .vendingMachine:
            return "Vending Machine"
        case .parking:
            return "Parking"
        case .gasStation:
            return "Gas Station"
        case .foodCourt:
            return "Food Court"
        case .other:
            return "Other"
        }
    }
}
