//
//  AppTabbar.swift
//  RealtyPro
//


import SwiftUI

struct AppTabbar: View {
    var body: some View {
        TabView {
            Text("First Tab")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Tab 1")
                }
                .tag(0)

            Text("Second Tab")
                .tabItem {
                    Image(systemName: "square.stack.3d.down.right.fill")
                    Text("Collections")
                }
                .tag(1)
            
            Text("Third Tab")
                .tabItem {
                    Image(systemName: "location.magnifyingglass")
                    Text("Search")
                }
                .tag(2)
            
            Text("Forth Tab")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Search")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    AppTabbar()
}
