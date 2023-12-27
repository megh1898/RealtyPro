//
//  SplashScreen.swift
//  RealtyPro
//

import SwiftUI

struct SplashScreen: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if isActive {
                LoginScreen()
            } else {
                TagLineText()
                    .padding(20)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct TagLineText: View {
    @State private var isAnimated = false
    
    var body: some View {
        VStack {
            HStack {
                Text("RealtyPro")
                    .bold()
                    .foregroundStyle(.blue)
                    .font(.largeTitle)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.easeInOut, value: 1)
                Spacer()
            }
            
            HStack {
                Text("Your Ultimate Real Estate Companion")
                    .bold()
                    .foregroundStyle(.black.opacity(0.75))
                    .font(.title)
                    .opacity(isAnimated ? 1 : 0)
                    .animation(.easeInOut, value: 1)
                Spacer()
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .onAppear {
            withAnimation {
                isAnimated = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}
