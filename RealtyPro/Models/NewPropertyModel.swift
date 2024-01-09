//
//  NewPropertyModel.swift
//  RealtyPro
//
//  Created by Macbook on 01/01/2024.
//

import Foundation

struct Property: Identifiable, Codable {
    var id = UUID()
    var name: String
    var details: String
    var price: String
    var location: String
    var latitude: Double
    var longitude: Double
    var filtersType: String
    var imagePaths: [String]
    var owner: String
    
    var asDictionary: [String: Any] {
        [
            "id": id.uuidString,
            "name": name,
            "details": details,
            "price": price,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "filtersType": filtersType,
            "imagePaths": imagePaths,
            "owner": owner
        ]
    }
}
