//
//  ProfileInformationScreen.swift
//  RealtyPro
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileInformationScreen: View {
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var alertMessage = ""
    @State private var imageURL = ""
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImages: [UIImage] = []
    @State private var showAlert = false
    
    var body: some View {
        VStack {
                            
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack(alignment: .center) {
                            
                            if selectedImages.isEmpty {
                                WebImage(url: URL(string: imageURL))
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                            } else {
                                CustomImageView(image: selectedImages.last ?? UIImage(named: "home")!)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .clipShape(Circle())
                            }
                            
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
                
                Section(header: Text("Personal Details")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email).disabled(true)
                    TextField("Phone", text: $phone)
                }
                
                Section {
                    Button(action: {
                        updateProfile()
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            guard let id = AppUtility.shared.userId else {return}
            FirestoreManager.shared.getLoggedInUserByUID(uid: id)
            name = AppUtility.shared.name ?? ""
            phone = AppUtility.shared.phone ?? ""
            email = AppUtility.shared.email ?? ""
            imageURL = AppUtility.shared.profileImage ?? ""
        }
    }
    
    private func updateProfile() {
        if name.isEmpty || phone.isEmpty {
            showAlert = true
            alertMessage = "Please fill all the fields"
            return
        }
        
        if let image = selectedImages.last {
            FirestoreManager.shared.uploadData(image: image) { imageURL, err in
                if err == nil {
                    FirestoreManager.shared.updateLoggedInUserByUID(newName: name, newPhone: phone, imageURL: imageURL?.absoluteString ?? "") { isSuccess in
                        if isSuccess {
                            showAlert = true
                            alertMessage = "Profile Updated Successfully"
                            AppUtility.shared.name = name
                            AppUtility.shared.phone = phone
                            AppUtility.shared.profileImage = imageURL?.absoluteString
                        } else {
                            showAlert = true
                            alertMessage = "Something went wrong, please try again later."
                        }
                    }
                } else {
                    showAlert = true
                    alertMessage = "Something went wrong, please try again later."
                }
            }
        } else {
            FirestoreManager.shared.updateLoggedInUserByUID(newName: name, newPhone: phone, imageURL: "") { isSuccess in
                if isSuccess {
                    showAlert = true
                    alertMessage = "Profile Updated Successfully"
                    AppUtility.shared.name = name
                    AppUtility.shared.phone = phone
                } else {
                    showAlert = true
                    alertMessage = "Something went wrong, please try again later."
                }
            }
        }
        
    }
}

//#Preview {
//    ProfileInformationScreen()
//}
