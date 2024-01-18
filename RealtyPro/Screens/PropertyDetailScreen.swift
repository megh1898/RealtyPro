//
//  PropertyDetailScreen.swift
//  RealtyPro
//
import SwiftUI
import SDWebImageSwiftUI
import MapKit
import MessageUI


struct PropertyDetailScreen: View {
    @State var property: Property
    @State private var imageURL: URL?
    @State private var isFavorite = false
    @State private var showAlert = false
    @State private var ownerName = ""
    @State var price: String = ""
    @State var alertMessage: String = ""
    
    @State var sellerProfile: UserProfileModel? = nil
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WebImage(url: imageURL)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 310)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(property.name).font(.title).bold()
                            }
                            Spacer()
                            
                            if property.owner != AppUtility.shared.userId {
                                Button(action: {
                                    favoriteProperty()
                                }, label: {
                                    let image = isFavorite ? "heart.fill" : "heart"
                                    Image(systemName: image)
                                        .font(.title2)
                                        .tint(.red)
                                })
                            }
                        }
                        Divider()
                        Text(property.location).font(.body)
                        Text("Price: $\(property.price)").font(.subheadline).bold()
                        Divider()
                        Text(property.details).font(.callout)
                            .foregroundColor(Color.primary.opacity(0.8))
                        Divider()
                        
                        if property.owner != AppUtility.shared.userId { 
                            Text("Contact Seller?")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                            Text("Email at \(property.ownerEmail)")
                            
                            Button(action: {
                                if let url = URL(string: "tel://\(property.ownerPhone)") {
                                    UIApplication.shared.open(url)
                                }
                            }, label: {
                                Text("Call at \(property.ownerPhone)")
                            })
                            
                            Divider()
                        }
                        
//                        if property.owner != AppUtility.shared.userId {
// 
//                            TextField("Enter an Amountmak", text: $price)
//                                .keyboardType(.numberPad)
//                                .padding()
//                            
//                            Button(action: {
//                                makeOffer()
//                            }, label: {
//                                Text("Make Offer")
//                                    .frame(height: 20)
//                                    .frame(minWidth: 0, maxWidth: .infinity)
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.blue)
//                                    .cornerRadius(6)
//                                    .bold()
//                            })
//                            
//                            Divider()
//                        }
                        
                        ZStack {
                            Map(coordinateRegion: .constant(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )), showsUserLocation: false, userTrackingMode: .none, annotationItems: [property]) { property in
                                // Add pin to the map
                                MapPin(coordinate: CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude), tint: .red)
                            }
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .frame(height: 200)
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(property.name)
        }
        .onAppear {
            FirestoreManager.shared.getImageURL(for: property.imagePaths.first ?? "") { imageURL in
                if let imageURL = imageURL {
                    self.imageURL = imageURL
                } else { }
            }
            
            FirestoreManager.shared.isPropertyFavorite(propertyId: property.id.uuidString) { isFvrt, err in
                if err == nil {
                    self.isFavorite = isFvrt
                }
            }
            
            FirestoreManager.shared.getUserByUID(uid: property.owner) { profile, error in
                if profile != nil {
                    ownerName = profile?.name ?? ""
                    self.sellerProfile = profile
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alert"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func makeOffer() {
        if price.isEmpty {
            showAlert = true
            alertMessage = "Please enter an amount."
            return
        }
        else if Int(price) == 0 {
            showAlert = true
            alertMessage = "Please enter valid amount."
            return
        } else {
            showAlert = true
            alertMessage = "Offer sent to seller. You will be notified when sellet accepts the offer."
        }
        
        
    }
    
    private func favoriteProperty() {
        let id = property.id.uuidString
        if isFavorite {
            FirestoreManager.shared.deleteFavoriteProperty(favoritePropertyId: id) { err in
                if err == nil {
                    isFavorite = false
                }
            }
        } else {
            FirestoreManager.shared.addFavorite(propertyId: id) { err in
                if err == nil {
                    isFavorite = true
                }
            }
        }
    }
}
struct PropertyDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProperty = Property(
            name: "Sample Property",
            details: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            price: "1,000,000",
            location: "123 Main St, City",
            latitude: 37.7749,
            longitude: -122.4194,
            filtersType: "Sale",
            imagePaths: ["https://picsum.photos/200"],
            owner: "John Doe",
            ownerEmail: "email@email.co",
            ownerPhone: "0010020203"
        )
        
        PropertyDetailScreen(property: sampleProperty)
    }
}

