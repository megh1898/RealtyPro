//
//  LoginScreen.swift
//  RealtyPro
//


import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    var body: some View {
        ZStack {
            ImageContainerView()
            VStack() {
                AppTagView(title: "RealtyPro")
                LoginFieldsView(viewModel: viewModel)
                LoginChoicesView(viewModel: viewModel)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $viewModel.isProcessCompleted.0) {
            AppTabbar()
        }
    }
}


struct ImageContainerView: View {
    var body: some View {
        Color.clear
            .overlay (
                Image("home")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .clipped()
    }
}

struct AppTagView: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                .padding(20)
            
            Spacer()
        }
    }
}

struct LoginChoicesView: View {
    
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            Button(action: {
                viewModel.login()
            }, label: {
                Text("Login")
                    .frame(height: 20)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(6)
                    .bold()
            })
            
            Text("Or")
                .foregroundStyle(.white)
                .bold()
            
            NavigationLink {
                SignupScreen(viewModel: viewModel)
            } label: {
                Text("Signup")
                    .frame(height: 20)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(6)
                    .bold()
            }
        }
        .padding(20)
        .alert(isPresented: $viewModel.isInvalidLogin) {
            Alert(
                title: Text("Invalid Login Credentials"),
                message: Text("Please enter valid Email and Password"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct LoginFieldsView: View {
    
    @State private var email: String = ""
    @State private var password : String = ""
    @ObservedObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        
        VStack(spacing: -16) {
            TextField("Email", text: $viewModel.email)
                .padding()
                .frame(height: 44)
                .background(.white.opacity(0.8))
                .cornerRadius(6)
                .padding()
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .frame(height: 44)
                .background(.white.opacity(0.8))
                .cornerRadius(6)
                .padding()
            
        }
        
    }
}

#Preview {
    LoginScreen()
}
