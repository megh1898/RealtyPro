//
//  MyPropertiesScreen.swift
//  RealtyPro
//


import SwiftUI
import SDWebImageSwiftUI

struct MyPropertiesScreen: View {
    
    @State private var properties = [Property]()
    
    var body: some View {
        List {
            ForEach(properties) { property in
                PropertyRow(property: property)
            }
            .onDelete(perform: deleteProperty)
        }
        .navigationTitle("My Properties")
        .onAppear {
            FirestoreManager.shared.getProperties { (properties, error) in
                if let error = error {
                    print("Error fetching properties: \(error.localizedDescription)")
                } else {
                    if let properties = properties {
                        self.properties = properties
                    }
                }
            }
        }
    }
    
    func deleteProperty(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let propertyId = properties[index].id.uuidString
        FirestoreManager.shared.deleteProperty(propertyID: propertyId) { error in
            if let error = error {
                print("Error deleting property from Firestore: \(error.localizedDescription)")
            } else {
                print("Property deleted successfully")
                properties.remove(atOffsets: indexSet)
            }
        }
    }
}

struct PropertyRow: View {
    @State private var imageURL: URL?
    var property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(property.imagePaths, id: \.self) { imagePath in
                        WebImage(url: imageURL)
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            
            Text(property.name)
                .font(.headline)
            
            Text("Details").foregroundStyle(.secondary).font(.footnote)
            Text(property.details)
            
            Text("Price:").foregroundStyle(.secondary).font(.footnote)
            Text("\(property.price)")
            
            Text("Location:").foregroundStyle(.secondary).font(.footnote)
            Text("\(property.location)")
            
            Text("Property Type:").foregroundStyle(.secondary).font(.footnote)
            Text("\(property.filtersType)")
        }
        .padding()
        .onAppear {
            FirestoreManager.shared.getImageURL(for: property.imagePaths.first ?? "") { imageURL in
                if let imageURL = imageURL {
                    self.imageURL = imageURL
                } else { }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyPropertiesScreen()
    }
}
