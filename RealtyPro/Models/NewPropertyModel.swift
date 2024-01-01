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
    var location: String
    var details: String
    var price: String
    var imagePaths: [String]
    
    var asDictionary: [String: Any] {
        [
            "name": name,
            "location": location,
            "details": details,
            "price": price,
            "imagePaths": imagePaths,
        ]
    }
}
