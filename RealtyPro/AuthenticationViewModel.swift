//
//  SignInViewModel.swift
//  RealtyPro
//
//

import SwiftUI

enum CustomError: Error {
    case authenticationFailed
    case error(msg: String)
    case unknown
}


@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isProcessing = false
    @Published var isProcessCompleted: (Bool, String) = (false, "")
    
    func login() {
        
        guard !email.isEmpty, !password.isEmpty else {
            print ("No email or password found.")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.loginUser(email: email, password: password)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func registerUser() {
        
        if !email.isValidateEmail()
            || !password.isValidPassword()
            || name.isEmpty
            || (password != confirmPassword) {
            isProcessCompleted = (true, "Please fill all the fields")
            return
        }
        isProcessing = true
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print (returnedUserData)
                isProcessing = false
                isProcessCompleted = (true, "User Registered Successfully")
            } catch {
                isProcessing = false
                isProcessCompleted = (true, error.localizedDescription)
            }
        }
    }
    
}
