//
//  LocationsOnMapScreen.swift
//  RealtyPro
//
//  Created by Macbook on 09/01/2024.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation

struct LocationsOnMapScreen: View {

    @State private var properties = [Property]()
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion()

    @State private var searchText: String = ""

    var body: some View {
        VStack {
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: properties) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                )) {
                    NavigationLink(destination: PropertyDetailScreen(property: location)) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .font(.largeTitle)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.blue)
                                .padding()

                            Text(location.name).foregroundColor(Color.black)
                                .bold()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .onAppear {
            FirestoreManager.shared.getAllProperties { result in
                switch result {
                case .success(let properties):
                    self.properties = properties
                    self.latitude = properties.first?.latitude ?? 0
                    self.longitude = properties.first?.longitude ?? 0
                    mapRegion = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: latitude,
                            longitude: longitude
                        ),
                        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                    )
                    print("Successfully fetched properties:", properties)
                case .failure(let error):
                    print("Error fetching properties:", error.localizedDescription)
                }
            }
        }
    }

//    private func updateMapRegion() {
//        if let firstLocation = filteredLocations.first {
//            mapRegion = MKCoordinateRegion(
//                center: CLLocationCoordinate2D(
//                    latitude: firstLocation.latitude,
//                    longitude: firstLocation.longitude
//                ),
//                span: mapRegion.span
//            )
//        }
//    }
}


struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isPressed ? Color.gray : Color.blue, lineWidth: 2)
            )
            .foregroundColor(configuration.isPressed ? Color.gray : Color.blue)
            .animation(.easeInOut)
    }
}

#Preview {
    LocationsOnMapScreen()
}
