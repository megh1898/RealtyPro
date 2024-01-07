//
//  PropertyDetailScreen.swift
//  RealtyPro
//
import SwiftUI
import SDWebImageSwiftUI
import MapKit
struct UserLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct PropertyDetailScreen: View {
    var property: Property

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    WebImage(url: URL(string: "https://picsum.photos/200")!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 310)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .clipped()
                    
                    VStack {
                        HStack {
                            Text("location title")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                                .padding(.vertical, 15)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text("Location Description")
                            .multilineTextAlignment(.leading)
                            .font(.body)
                            .foregroundColor(Color.primary.opacity(0.9))
                            .padding(.bottom, 25)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct PropertyDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        let property = Property(name: "Toronto", location: "Canada", details: "Best location to live in with family, with all the facilities nearby and a balcony with a sea view", price: "$200,000", imagePaths: [])
        PropertyDetailScreen(property: property)
    }
}
