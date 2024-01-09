//
//  LocalSearchViewData.swift
//  RealtyPro
//
//  Created by Macbook on 08/01/2024.
//

import CoreLocation
import MapKit
import Foundation

struct LocalSearchViewData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var location: CLLocation
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
        self.location = mapItem.placemark.location ?? CLLocation(latitude: 37.7749, longitude: -122.4194)
    }
}
