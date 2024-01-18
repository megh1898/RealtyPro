//
//  OfferScreen.swift
//  RealtyPro
//
//  Created by Macbook on 18/01/2024.
//

import SwiftUI

struct OfferScreen: View {
    @Binding var sellerProfile: UserProfileModel?
    
    @State var price: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Offered Price", text: $price)
                }
                
                Section {
                    Button(action: {
                        print("sdc")
                    }, label: {
                        Text("Login")
                            .frame(height: 20)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(6)
                            .bold()
                    })
                }
            }
        }
        .navigationTitle("Details")
    }
}

