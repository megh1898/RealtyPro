//
//  AppTabbar.swift
//  RealtyPro
//


import SwiftUI

struct AppTabbar: View {
    var body: some View {
        NavigationStack{
            TabView {
                HomeScreen()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)

                Text("Second Tab")
                    .tabItem {
                        Image(systemName: "square.stack.3d.down.right.fill")
                        Text("Collections")
                    }
                    .tag(1)
                
                AddNewPropertyScreen()
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill.badge.plus")
                        Text("Add New")
                    }
                    .tag(2)
                
                Text("Forth Tab")
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Search")
                    }
                    .tag(3)
                
                ProfileScreen()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .accentColor(.blue)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                let _ = try? AuthenticationManager.shared.getAuthenticatedUser()
            }
        }
    }
}

#Preview {
    AppTabbar()
}
