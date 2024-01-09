//
//  ProfileScreen.swift
//  RealtyPro
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileScreen: View {
    @State private var imageURL: URL?
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                WebImage(url: imageURL)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                                
                                Text(AppUtility.shared.name ?? "")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: MyPropertiesScreen()) {
                            CustomProfileView(icon: "list.triangle", title: "My Properties")
                        }
                        NavigationLink(destination: MyPropertiesScreen(isMyProperties: false)) {
                            CustomProfileView(icon: "heart.square", title: "My Favourite Properties")
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: ProfileInformationScreen()) {
                            CustomProfileView(icon: "person.circle", title: "Account Details")
                        }
                    }
                    
                    Section {
                        Button(action: {
                            
                        }, label: {
                            Text("Logout")
                                .frame(maxWidth: .infinity)
                        })
                    }
                }
            }
            .navigationBarTitle("Hello, \(AppUtility.shared.name ?? "")")
            .onAppear {
                guard let url = AppUtility.shared.profileImage else {return} // string url
                imageURL = URL(string: url)
            }
        }
    }
}

//#Preview {
//    ProfileScreen()
//}


struct MyFavouritePropertiesScreen: View {
    var body: some View {
        Text("My Favourite Properties Screen")
            .navigationBarTitle("My Favourite Properties")
    }
}

struct AccountDetailsScreen: View {
    var body: some View {
        Text("Account Details Screen")
            .navigationBarTitle("Account Details")
    }
}

struct CustomProfileView: View {
    let icon: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
        }
    }
}
