//
//  AddNewPropertyScreen.swift
//  RealtyPro
//


import SwiftUI
struct Property: Identifiable {
    var id = UUID()
    var name: String
    var location: String
    var details: String
    var price: String
}

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
                            let _ = Property(name: name, location: location, details: details, price: price)
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
