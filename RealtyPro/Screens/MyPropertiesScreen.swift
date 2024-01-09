//
//  MyPropertiesScreen.swift
//  RealtyPro
//
//  Created by Macbook on 09/01/2024.
//

import SwiftUI



struct MyPropertiesScreen: View {
    
    @State private var properties = [Property]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(properties) { property in
                    PropertyRow(property: property)
                }
                .onDelete(perform: deleteProperty)
            }
            .navigationTitle("My Properties")
        }
    }
    
    func deleteProperty(at offsets: IndexSet) {
        properties.remove(atOffsets: offsets)
    }
}

struct PropertyRow: View {
    var property: Property
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(property.imagePaths, id: \.self) { imagePath in
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .padding(5)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyPropertiesScreen()
    }
}
