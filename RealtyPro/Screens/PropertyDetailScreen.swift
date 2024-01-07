//
//  PropertyDetailScreen.swift
//  RealtyPro
//


import SwiftUI

//struct PropertyDetailScreen: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                Image("home")
////                        .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 300)
//                
//                VStack(alignment: .leading) {
//                    Text("Some Random Property")
//                        .font(.title)
//                    
//                    Text("Some Random Property, Some Random Property, Some Random Property, Some Random Property, Some Random Property, Some Random Property")
//                        .font(.footnote)
//                }
//                
//                Rectangle()
//                    .frame(height: 600)
//            }
//            
//        }
//        .navigationBarTitle("Add New Property")
//    }
//}


import SwiftUI

struct PropertyDetailScreen: View {
    var property: Property

    var body: some View {
        VStack {
            // Title and Body
            VStack(alignment: .leading, spacing: 10) {
                Text(property.name)
                    .font(.title)
                    .bold()
                    .padding(.top, 10)

                Text("Location: \(property.location)")
                    .foregroundColor(.gray)

                Text(property.details)
                    .padding(.top, 10)

                Text("Price: \(property.price)")
                    .foregroundColor(.blue)
                    .padding(.top, 5)

            }
            .padding(15)
            
            Spacer()
        }
        .navigationBarTitle(property.name, displayMode: .inline)
    }
}
