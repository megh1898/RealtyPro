//
//  UserDefaults.swift
//  RealtyPro
//


import Foundation

struct UserDefaultsKeys {
    static let email = "email"
    static let name = "name"
    static let phone = "phone"
    static let userId = "userId"
    static let profileImage = "profileImage"

    
}

class AppUtility: NSObject, ObservableObject {
    
    static let shared = AppUtility()
    
    var email: String? {
        didSet {
            UserDefaults.standard.set(self.email, forKey: UserDefaultsKeys.email)
        }
    }
    
    var name: String? {
        didSet {
            UserDefaults.standard.set(self.name, forKey: UserDefaultsKeys.name)
        }
    }
    
    var phone: String? {
        didSet {
            UserDefaults.standard.set(self.phone, forKey: UserDefaultsKeys.phone)
        }
    }
    
    
    var userId: String? {
        didSet {
            UserDefaults.standard.set(self.userId, forKey: UserDefaultsKeys.userId)
        }
    }
    
    var profileImage: String? {
        didSet {
            UserDefaults.standard.set(self.profileImage, forKey: UserDefaultsKeys.profileImage)
        }
    }
    
}

