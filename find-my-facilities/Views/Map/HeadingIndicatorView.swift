//
//  HeadingIndicatorView.swift
//  find-my-facilities
//
//  Created by Silas Nevstad on 11/29/24.
//

import SwiftUI

struct HeadingIndicatorView: View {
    var heading: Double

    var body: some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: heading))
            .background(Color.white.opacity(0.7))
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}

