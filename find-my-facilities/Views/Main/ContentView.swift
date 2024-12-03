//
//  ContentView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .map

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .map:
                    MapView()
                case .list:
                    ListView()
                }
            }
            .edgesIgnoringSafeArea(.all)

            // Custom Tab Bar
            CustomTabBarView(selectedTab: $selectedTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FacilitiesViewModel())
    }
}
