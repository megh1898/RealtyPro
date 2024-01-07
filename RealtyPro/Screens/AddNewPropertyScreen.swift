//
//  AddNewPropertyScreen.swift
//  RealtyPro
//


import SwiftUI

struct AddNewPropertyScreen: View {
    
    @State private var name = ""
    @State private var location = ""
    @State private var details = ""
    @State private var price = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Property Details")) {
                        TextField("Name", text: $name)
                        TextField("Location", text: $location)
                        TextField("Details", text: $details)
                        TextField("Price", text: $price)
                    }
                    
                    Section(header: Text("Property Images")) {
                        
                        Button("Add Images") {
                            isImagePickerPresented.toggle()
                        }
                        
                        ScrollView(.horizontal) {
                            HStack {
                                SelectedImagesView(selectedImages: $selectedImages)
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            let item = Property(name: name, location: location, details: details, price: price, imagePaths: [])
                            addProperty(property: item, images: selectedImages)
                        }, label: {
                            Text("Add Property")
                                .frame(maxWidth: .infinity)
                        })
                        
                    }
                }
            }
            .navigationBarTitle("Add New Property")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }
    
    private func addProperty(property: Property, images: [UIImage]) {
        FirestoreManager.shared.savePropertyToFirestore(property: property, images: images) { error in
            if let error = error {
                print("Error saving property to Firestore: \(error.localizedDescription)")
            } else {
                print("Property saved successfully to Firestore")
            }
        }
    }
    
}

#Preview {
    AddNewPropertyScreen()
}

struct SelectedImagesView: View {
    
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollView in
                HStack(spacing: 20) {
                    ForEach(selectedImages, id: \.self) { image in
                        CustomImageView(image: image)
                            .frame(width: 140, height: 140)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
