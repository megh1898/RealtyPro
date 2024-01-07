//
//  String+Extensions.swift
//  RealtyPro
//


import Foundation


extension String {
    
    func isValidateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        if self.count > 6 && self.count < 10 {
            return true
        } else {
            return false
        }
    }
    
}
