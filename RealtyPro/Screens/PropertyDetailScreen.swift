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
                        Text("Price: $\(property.price)").font(.subheadline)
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
