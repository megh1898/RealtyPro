//
//  AllPropertiesListScreen.swift
//  RealtyPro
//


import SwiftUI

struct AllPropertiesListScreen: View {
    
    @State var category: CategoriesModel?
    @Binding var propertiesList: [Property]
    
    var body: some View {
        VStack {
            PropertyListingView(properties: $propertiesList)
            Spacer()
        }
        .onAppear {
            if category != nil {
                propertiesList = propertiesList.filter({
                    $0.filtersType == category?.text
                })
            }
        }
        .navigationTitle("Properties")
    }
}
