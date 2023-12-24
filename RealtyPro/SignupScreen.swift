//
//  SignupScreen.swift
//  RealtyPro
//


import SwiftUI


struct SignupScreen: View {
        
    var body: some View {
                
        ZStack {
            ImageContainerView()
            VStack() {
                AppTagView(title: "Singup")
                SignupFieldsView()
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            
        }
        .ignoresSafeArea(.all)
    }
}


struct SignupFieldsView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {
        
        ZStack {
            VStack(spacing: -16) {
                
                CustomTextFieldView(title: "Name", text: $viewModel.name)
                CustomTextFieldView(title: "Email", text: $viewModel.email)
                CustomSecureTextFieldView(title: "Password", text: $viewModel.password)
                CustomSecureTextFieldView(title: "Confirm Password", text: $viewModel.confirmPassword)
                
                Button(action: {
                    viewModel.registerUser()
                }, label: {
                    Text("Signup")
                        .frame(height: 20)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(6)
                        .bold()
                        .padding(20)
                })
                
            }
            if viewModel.isProcessing {
                ProgressCustomView(title: "Signing Up...")
            }
        }
        .alert(isPresented: $viewModel.isProcessCompleted.0) {
            Alert(
                title: Text("Alert"),
                message: Text(viewModel.isProcessCompleted.1),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
}

#Preview {
    SignupScreen()
}


struct CustomTextFieldView: View {
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .frame(height: 44)
            .background(.white.opacity(0.8))
            .cornerRadius(6)
            .padding()
    }
}

struct CustomSecureTextFieldView: View {
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        SecureField(title, text: $text)
            .padding()
            .frame(height: 44)
            .background(.white.opacity(0.8))
            .cornerRadius(6)
            .padding()
    }
}

struct ProgressCustomView: View {
    
    var title: String
    
    var body: some View {
        ProgressView(title)
            .frame(width: 150, height: 150)
            .background(Color.gray)
            .cornerRadius(8.0)
    }
}
