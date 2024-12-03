//
//  FilterView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var viewModel: FacilitiesViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Facility Types")) {
                    ForEach(FacilityType.allCases) { type in
                        Toggle(isOn: Binding(
                            get: {
                                viewModel.selectedTypes.contains(type)
                            },
                            set: { isSelected in
                                if isSelected {
                                    viewModel.selectedTypes.insert(type)
                                } else {
                                    viewModel.selectedTypes.remove(type)
                                }
                            }
                        )) {
                            Text(type.displayName)
                        }
                    }
                }

                Section(header: Text("Proximity")) {
                    VStack {
                        Text("Within \(Int(viewModel.proximityFilter / 1000)) km")
                        Slider(value: $viewModel.proximityFilter, in: 500...5000, step: 500)
                            .accentColor(.blue)
                    }
                }
            }
            .navigationTitle("Filter Facilities")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
