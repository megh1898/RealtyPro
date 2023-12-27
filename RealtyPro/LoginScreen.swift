//
//  LoginScreen.swift
//  RealtyPro
//


import SwiftUI

struct LoginScreen: View {
    
    var body: some View {
        ZStack {
            ImageContainerView()
            VStack() {
                AppTagView(title: "RealtyPro")
                LoginFieldsView()
                LoginChoicesView()
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
            
        }
        .ignoresSafeArea(.all)
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
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Button(action: {
                isLoggedIn.toggle()
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
                SignupScreen()
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
        .navigationDestination(isPresented: $isLoggedIn) {
            AppTabbar()
        }
    }
}

struct LoginFieldsView: View {
    
    @State private var email: String = ""
    @State private var password : String = ""
    
    var body: some View {
        
        VStack(spacing: -16) {
            TextField("Email", text: $email)
                .padding()
                .frame(height: 44)
                .background(.white.opacity(0.8))
                .cornerRadius(6)
                .padding()
            
            SecureField("Password", text: $password)
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
