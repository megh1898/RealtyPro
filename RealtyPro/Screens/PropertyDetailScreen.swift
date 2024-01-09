//
//  PropertyDetailScreen.swift
//  RealtyPro
//
import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct PropertyDetailScreen: View {
    @State var property: Property
    @State private var imageURL: URL?
    
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
                            Text(property.name).font(.title).bold()
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .tint(.red)
                            })
                        }
                        Divider()
                        Text(property.location).font(.body)
                        Text("Price: $\(property.price)").font(.subheadline)
                        Divider()
                        Text(property.details).font(.callout)
                            .foregroundColor(Color.primary.opacity(0.8))
                        Divider()
                        
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
        }
        .navigationBarItems(trailing:
                                Button(action: {
            if let url = URL(string: "tel://\(0123456789)") {
                UIApplication.shared.open(url)
            }
        }) {
            Image(systemName: "phone.fill")
                .font(.title3)
                .foregroundColor(.blue)
        }
        )
        
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
            owner: "John Doe"
        )

        PropertyDetailScreen(property: sampleProperty)
    }
}
