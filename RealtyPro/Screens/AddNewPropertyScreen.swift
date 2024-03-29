//
//  AddNewPropertyScreen.swift
//  RealtyPro
//


import SwiftUI
import CoreLocation
import SDWebImageSwiftUI

struct AddNewPropertyScreen: View {
    
    @State private var name = ""
    @State private var details = ""
    @State private var price = ""
    
    @State private var filtersType = "Recently Sold"
    
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false
    
    @State var searchedLocation: LocalSearchViewData? = nil
    @State private var isMapViewPresented = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            
            ZStack {
                VStack {
                    Form {
                        Section(header: Text("Property Details")) {
                            TextField("Name", text: $name)
                            TextField("Details", text: $details)
                            TextField("Price", text: $price)
                                .keyboardType(.numberPad)
                        }
                        
                        Section(header: Text("Property Location"))  {
                            Button("Add Location") {
                                isMapViewPresented.toggle()
                            }
                            if searchedLocation != nil {
                                VStack(alignment: .leading) {
                                    Text(searchedLocation?.title ?? "")
                                        .bold()
                                    Text(searchedLocation?.subtitle ?? "")
                                }
                            }
                        }
                        
                        Section(header: Text("Filters"))  {
                            Picker("Filters", selection: $filtersType) {
                                Text("Recently Sold").tag("Recently Sold")
                                Text("For Rent").tag("For Rent")
                                Text("Open Houses").tag("Open Houses")
                                Text("New Homes").tag("New Homes")
                                Text("Condos").tag("Condos")
                                Text("Studio").tag("Studio")
                            }
                            .pickerStyle(MenuPickerStyle())
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
                                if isValidInput() {
                                    let property = Property(name: name, details: details,
                                                            price: price.removingLeadingZeros(), location: searchedLocation?.subtitle ?? "",
                                                            latitude: searchedLocation?.location.coordinate.latitude ?? 0,
                                                            longitude: searchedLocation?.location.coordinate.longitude ?? 0,
                                                            filtersType: filtersType, imagePaths: [], 
                                                            owner: AppUtility.shared.userId!,
                                                            ownerEmail: AppUtility.shared.email!,
                                                            ownerPhone: AppUtility.shared.phone!)
                                    
                                    addProperty(property: property, images: selectedImages)
                                } else {
                                    showAlert = true
                                }
                            }, label: {
                                Text("Add Property")
                            })
                            .disabled(isLoading)
                        }
                    }
                    
                }
                if isLoading {
                    ProgressCustomView(title: "Saving...")
                }
            }
            
            
            .navigationBarTitle("Add New Property")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImages: $selectedImages)
            }
            .sheet(isPresented: $isMapViewPresented) {
                SearchLocationsScreen(location: $searchedLocation)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func isValidInput() -> Bool {
        
        if name.isEmpty {
            alertMessage = "Please enter a name."
            return false
        }
        
        if details.isEmpty {
            alertMessage = "Please provide details."
            return false
        }
        
        if price.isEmpty {
            alertMessage = "Please enter a price."
            return false
        }
        
        if Int(price) == 0 {
            alertMessage = "Please enter valid price."
            return false
        }
        
        if searchedLocation == nil {
            alertMessage = "Please select a location."
            return false
        }
        
        if selectedImages.isEmpty {
            alertMessage = "Please choose at least one image."
            return false
        }
        
        return true
    }

    
    private func clearFields() {
        name = ""
        details = ""
        price = ""
        searchedLocation = nil
        selectedImages.removeAll()
    }
    
    private func addProperty(property: Property, images: [UIImage]) {
        isLoading = true
        FirestoreManager.shared.savePropertyToFirestore(property: property, images: images) { error in
            isLoading = false
            showAlert = true
            if let error = error {
                alertMessage = "Error saving property to Firestore: \(error.localizedDescription)"
            } else {
                alertMessage = "Property added successfully"
            }
        }
    }
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
extension String {
    func removingLeadingZeros() -> String {
        var result = self
        while result.first == "0" {
            result.removeFirst()
        }
        return result
    }
}
