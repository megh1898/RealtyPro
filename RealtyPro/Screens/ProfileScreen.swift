//
//  ProfileScreen.swift
//  RealtyPro
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                                
                Form {
                    Section {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                CustomImageView(image: UIImage(named: "home")!)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                                
                                Text("John Doe")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    
                    Section {
                        CustomProfileView(icon: "list.triangle", title: "My Properties")
                        CustomProfileView(icon: "heart.square", title: "My Favourite Properties")
                    }
                    
                    Section {
                        CustomProfileView(icon: "person.circle", title: "Account Details")
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
            .navigationBarTitle("Hello, John")
        }
    }
}

#Preview {
    ProfileScreen()
}

struct CustomProfileView: View {
    let icon: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundStyle(.tertiary)
        }
    }
}
