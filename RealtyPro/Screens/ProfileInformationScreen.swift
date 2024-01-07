//
//  ProfileInformationScreen.swift
//  RealtyPro
//
//  Created by Macbook on 07/01/2024.
//

import SwiftUI

struct ProfileInformationScreen: View {
    
    @State private var name = ""
    @State private var location = ""
    @State private var details = ""
    @State private var price = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        NavigationView {
            VStack {
                                
                Form {
                    Section {
                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                CustomImageView(image: selectedImages.first ?? UIImage(named: "home")!)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                                
                                Button(action: {
                                    isImagePickerPresented.toggle()
                                }, label: {
                                    Text("Change Profile Image")
                                        .frame(maxWidth: .infinity)
                                })
                            }
                            Spacer()
                            
                        }
                    }
                    
                    Section(header: Text("Property Details")) {
                        TextField("Name", text: $name)
                        TextField("Email", text: $details)
                        TextField("Phone", text: $location)
                        TextField("Price", text: $price)
                    }
                    
                    Section {
                        Button(action: {
                            
                        }, label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                
                        })
                    }
                }
            }
            .navigationBarTitle("Profile Information")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }
}

#Preview {
    ProfileInformationScreen()
}
