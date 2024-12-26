//
//  LocationView.swift
//  ABoHa
//
//  Created by 이미진 on 11/21/24.
//


import SwiftUI

struct LocationView: View {
    @EnvironmentObject var locationManager:ForecastViewModel

    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Latitude: \(location.latitude)")
                Text("Longitude: \(location.longitude)")
            } else {
                Text("Fetching location...")
            }
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
    }
}

#Preview {
    LocationView().environmentObject(ForecastViewModel())
}
