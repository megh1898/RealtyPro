//
//  SignInViewModel.swift
//  RealtyPro
//
//

import SwiftUI
import FirebaseAuth

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
    @Published var phone = ""
    @Published var confirmPassword = ""
    
    @Published var isProcessing = false
    @Published var isProcessCompleted: (Bool, String) = (false, "")
    @Published var isInvalidLogin = false
    @Published var isInvalidSingup = false
    @Published var errorMessage = ""
    @Published var isAuthenticated: Bool = false
    
    func login() {
        
        if !email.isValidateEmail() {
            isInvalidLogin = true
            errorMessage = "Invalid email address"
            return
        } else if !password.isValidPassword() {
            isInvalidLogin = true
            errorMessage = "Invalid password format, Minimum password length should be 7 characters"
            return
        }
        isProcessing = true
        Task {
            do {
                let user = try await AuthenticationManager.shared.loginUser(email: email, password: password)
                isProcessCompleted = (true, "")
                AppUtility.shared.email = email
                AppUtility.shared.userId = user.uid
                isAuthenticated = true
                isProcessing = false
            } catch {
                print("Error: \(error)")
                isInvalidLogin = true
                errorMessage = error.localizedDescription
                isProcessing = false
            }
        }
    }
    
    func registerUser() {
        
        if name.isEmpty {
            errorMessage = "Name cannot be empty"
            isInvalidSingup = true
            return
        }
        
        else if !email.isValidateEmail() {
            errorMessage = "Invalid email format"
            isInvalidSingup = true
            return
        }

        else if phone.isEmpty {
            errorMessage = "Phone number cannot be empty"
            isInvalidSingup = true
            return
        }
        
        else if !password.isValidPassword() {
            errorMessage = "Invalid password format, Minimum password length should be 7 characters"
            isInvalidSingup = true
            return
        }
        
        else if password != confirmPassword {
            errorMessage = "Password and confirm password do not match"
            isInvalidSingup = true
            return
            
        }
        
        isProcessing = true
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                let result = try await AuthenticationManager.shared.registerUserInDatabase(user: returnedUserData, name: name, phone: phone)
                isProcessing = false
                isProcessCompleted = result
                isAuthenticated = true
            } catch {
                isInvalidSingup = true
                isProcessing = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            isProcessCompleted = (false, "")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
