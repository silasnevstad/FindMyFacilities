//
//  FacilitiesViewModel.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine
import CoreLocation
import MapKit

class FacilitiesViewModel: ObservableObject {
    @Published var userReportedFacilities: [Facility] = []
    @Published var standardFacilities: [Facility] = []
    @Published var filteredFacilities: [Facility] = []
    @Published var selectedTypes: Set<FacilityType> = Set(FacilityType.allCases)
    @Published var userLocation: CLLocation?
    @Published var heading: CLHeading? = nil
    @Published var selectedFacility: Facility? = nil
    @Published var showDirectionsModal: Bool = false
    @Published var directionsInfo: DirectionsInfo? = nil
    @Published var showFilterModal: Bool = false
    @Published var searchQuery: String = ""
    @Published var proximityFilter: Double = 1000 // Default radius in meters
    @Published var showReportModal: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let firebaseService = FirebaseService()
    private let locationManager = LocationManager()
    
    init() {
        // Assign Firebase facilities to userReportedFacilities
        firebaseService.$facilities
            .receive(on: DispatchQueue.main)
            .assign(to: \.userReportedFacilities, on: self)
            .store(in: &cancellables)
        
        // Assign user location and heading
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .assign(to: \.userLocation, on: self)
            .store(in: &cancellables)
        
        locationManager.$heading
            .receive(on: DispatchQueue.main)
            .assign(to: \.heading, on: self)
            .store(in: &cancellables)
        
        // Fetch standard facilities when user location updates, with debounce
        locationManager.$location
            .compactMap { $0 }
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .sink { [weak self] location in
                self?.fetchStandardFacilities(near: location)
            }
            .store(in: &cancellables)
        
        // Combine and filter facilities
        Publishers.CombineLatest4($userReportedFacilities, $standardFacilities, $selectedTypes, $searchQuery)
            .map { userFacilities, standardFacilities, selectedTypes, searchQuery in
                let combined = userFacilities + standardFacilities
                return combined.filter { facility in
                    selectedTypes.contains(facility.type) &&
                    (searchQuery.isEmpty || facility.name.lowercased().contains(searchQuery.lowercased()))
                }
            }
            .combineLatest($proximityFilter)
            .map { [weak self] facilities, radius in
                guard let self = self, let userLocation = self.userLocation else { return facilities }
                return facilities.filter { facility in
                    let facilityLocation = CLLocation(latitude: facility.latitude, longitude: facility.longitude)
                    let distance = userLocation.distance(from: facilityLocation)
                    return distance <= radius
                }
            }
            .assign(to: \.filteredFacilities, on: self)
            .store(in: &cancellables)
        
        // Observe selectedFacility to fetch directions
        $selectedFacility
            .sink { [weak self] facility in
                guard let self = self, let facility = facility, let userLocation = self.userLocation else {
                    self?.directionsInfo = nil
                    return
                }
                self.fetchDirections(from: userLocation, to: facility.locationCoordinate)
            }
            .store(in: &cancellables)
    }
    
    func selectFacility(_ facility: Facility) {
        selectedFacility = facility
        fetchDirectionsForSelectedFacility()
    }
    
    func addFacility(name: String, notes: String, type: FacilityType, coordinate: CLLocationCoordinate2D, reportedBy: String) {
        let newFacility = Facility(
            name: name,
            type: type,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            reportedBy: reportedBy,
            timestamp: Date(),
            notes: notes
        )
        firebaseService.addFacility(newFacility)
    }
    
    func toggleFilter(for type: FacilityType) {
        if selectedTypes.contains(type) {
            selectedTypes.remove(type)
        } else {
            selectedTypes.insert(type)
        }
    }
    
    /// Fetch directions and update directionsInfo
    func fetchDirectionsForSelectedFacility() {
        guard let facility = selectedFacility, let userLocation = userLocation else { return }
        
        fetchDirections(from: userLocation, to: facility.locationCoordinate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch directions: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] directions in
                self?.directionsInfo = directions
                self?.showDirectionsModal = true
            })
            .store(in: &cancellables)
    }
    
    /// Fetch directions using Apple's MapKit
    func fetchDirections(from: CLLocation, to: CLLocationCoordinate2D) -> AnyPublisher<DirectionsInfo, Error> {
        Future<DirectionsInfo, Error> { promise in
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: from.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    promise(.failure(error))
                } else if let route = response?.routes.first {
                    let info = DirectionsInfo(distance: route.distance, expectedTravelTime: route.expectedTravelTime)
                    promise(.success(info))
                } else {
                    promise(.failure(NSError(domain: "No route found", code: 0, userInfo: nil)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Fetch standard facilities using MKLocalSearch
    func fetchStandardFacilities(near location: CLLocation, radius: Double = 1000, query: String = "public restroom") {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: radius,
                                            longitudinalMeters: radius)
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let response = response else {
                print("Error fetching standard facilities: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            
            let facilities = mapItems.compactMap { item -> Facility? in
                guard let name = item.name else { return nil }
                let facilityType = self.categorizeFacility(from: name)
                return Facility(
                    name: name,
                    type: facilityType,
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude,
                    reportedBy: "Apple",
                    timestamp: Date(),
                    notes: item.phoneNumber ?? ""
                )
            }
            
            DispatchQueue.main.async {
                self.standardFacilities.append(contentsOf: facilities)
            }
        }
    }
    
    /// Categorize facility based on its name
    private func categorizeFacility(from name: String) -> FacilityType {
        let lowercasedName = name.lowercased()
        
        // Define keyword mappings
        let bathroomKeywords = ["bathroom", "restroom", "toilet", "washroom", "wc"]
        let waterFountainKeywords = ["water", "fountain", "tap"]
        let vendingMachineKeywords = ["vending machine", "machine", "snack", "drink", "fridge"]
        let parkingKeywords = ["parking", "park", "garage"]
        let gasStationKeywords = ["gas station", "gas", "fuel station", "petrol"]
        let foodCourtKeywords = ["food court", "cafeteria", "restaurant", "cafe", "dining"]
        
        // Check for keywords in the name
        if bathroomKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .restroom
        }
        if waterFountainKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .waterFountain
        }
        if vendingMachineKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .vendingMachine
        }
        if parkingKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .parking
        }
        if gasStationKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .gasStation
        }
        if foodCourtKeywords.contains(where: { lowercasedName.contains($0) }) {
            return .foodCourt
        }
        
        return .other
    }
}
