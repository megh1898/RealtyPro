//
//  LoginScreen.swift
//  RealtyPro
//
//  Created by Macbook on 23/12/2023.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
                
        ZStack {
            ImageContainerView()
            VStack {
                WelcomeTextView()
                LoginChoicesView()
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(20)
            
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

struct WelcomeTextView: View {
    var body: some View {
        Text("RealtyPro")
            .font(.title)
            .bold()
            .foregroundStyle(.tint)
            .padding(20)
    }
}


struct LoginChoicesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                print("Login")
            }, label: {
                Text("Login")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .bold()
            })
            
            Button(action: {
                print("Signup")
            }, label: {
                Text("Signup")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .bold()
            })
        }
        .padding(20)
    }
}



#Preview {
    LoginScreen()
}
