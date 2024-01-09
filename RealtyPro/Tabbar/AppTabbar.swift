//
//  AppTabbar.swift
//  RealtyPro
//


import SwiftUI

struct AppTabbar: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    var body: some View {
            TabView {
                HomeScreen()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                AddNewPropertyScreen()
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill.badge.plus")
                        Text("Add New")
                    }
                    .tag(1)
                
                LocationsOnMapScreen()
                    .tabItem {
                        Image(systemName: "map.circle.fill")
                        Text("Map")
                    }
                    .tag(2)
                
                ProfileScreen(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .accentColor(.blue)
            .toolbar(.hidden, for: .navigationBar)
    }
}
