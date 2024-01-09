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
    @Published var email = "megh@gmail.com"
    @Published var password = "12121212"
    @Published var confirmPassword = ""
    
    @Published var isProcessing = false
    @Published var isProcessCompleted: (Bool, String) = (false, "")
    @Published var isInvalidLogin = false
    
    func login() {
        
        if !email.isValidateEmail() || !password.isValidPassword() {
            isInvalidLogin = true
            return
        }
        
        Task {
            do {
                let user = try await AuthenticationManager.shared.loginUser(email: email, password: password)
                isProcessCompleted = (true, "")
                AppUtility.shared.email = email
                AppUtility.shared.userId = user.uid
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
                let result = try await AuthenticationManager.shared.registerUserInDatabase(user: returnedUserData)
                isProcessing = false
                isProcessCompleted = result
            } catch {
                isProcessing = false
                isProcessCompleted = (true, error.localizedDescription)
            }
        }
    }
    
}
