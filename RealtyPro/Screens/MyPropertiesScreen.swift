//
//  MyPropertiesScreen.swift
//  RealtyPro
//


import SwiftUI
import SDWebImageSwiftUI

struct MyPropertiesScreen: View {
    
    @State private var properties = [Property]()
    var isMyProperties = true
    var body: some View {
        List {
            ForEach(properties) { property in
                PropertyRow(property: property)
            }
            .onDelete(perform: deleteProperty)
        }
        .navigationTitle(isMyProperties ? "My Properties" : "My Favorite Properties")
        .onAppear {
            getProperties()
        }
    }
    
    func getProperties() {
        if isMyProperties {
            FirestoreManager.shared.getProperties { (properties, error) in
                if let error = error {
                    print("Error fetching properties: \(error.localizedDescription)")
                } else {
                    if let properties = properties {
                        self.properties = properties
                    }
                }
            }
        } else {
            FirestoreManager.shared.fetchFavouriteList { properties, error in
                if let error = error {
                    print(error.localizedDescription)
                } else if let properties = properties {
                    self.properties = properties
                }
            }
        }
    }
    
    func deleteProperty(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let propertyId = properties[index].id.uuidString
        
        if isMyProperties {
            FirestoreManager.shared.deleteProperty(propertyID: propertyId) { error in
                if let error = error {
                    print("Error deleting property from Firestore: \(error.localizedDescription)")
                } else {
                    print("Property deleted successfully")
                    properties.remove(atOffsets: indexSet)
                }
            }
        }
        else {
            FirestoreManager.shared.deleteFavoriteProperty(favoritePropertyId: propertyId) { err in
                if let error = err {
                    print("Error removing favorite property: \(error.localizedDescription)")
                } else {
                    print("Favorite property removed successfully")
                    properties.remove(atOffsets: indexSet)
                }
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
