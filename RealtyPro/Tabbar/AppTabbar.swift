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
                
                CollectionsScreen()
                    .tabItem {
                        Image(systemName: "square.3.layers.3d.top.filled")
                        Text("Collections")
                    }
                    .tag(1)
                
                AddNewPropertyScreen()
                    .tabItem {
                        Image(systemName: "rectangle.stack.fill.badge.plus")
                        Text("Add New")
                    }
                    .tag(2)
                
                LocationsOnMapScreen()
                    .tabItem {
                        Image(systemName: "map.circle.fill")
                        Text("Map")
                    }
                    .tag(3)
                
                ProfileScreen(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .accentColor(.blue)
            .toolbar(.hidden, for: .navigationBar)
    }
}
