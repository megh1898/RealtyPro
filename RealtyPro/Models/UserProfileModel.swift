//
//  UserProfileModel.swift
//  RealtyPro
//
//  Created by Macbook on 18/01/2024.
//

import Foundation

struct UserProfileModel: Codable {
    var userId: String
    var email: String
    var phone: String
    var name: String
    var profileImage: String
}
