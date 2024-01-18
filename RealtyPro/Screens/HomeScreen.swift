//
//  HomeScreen.swift
//  RealtyPro
//


import SwiftUI
import SDWebImageSwiftUI

struct HomeScreen: View {
    
    @State private var properties = [Property]()
    @State private var categories: [CategoriesModel] = []
    @State private var allProperties = [Property]()
    var body: some View {
        
        VStack {
            
            Text("RealtyPro")
                .font(.title2)
                .bold()
                .padding(.horizontal, 1)
            
            ScrollView(.vertical) {
                
                VStack(spacing: 4) {
                    
                    TitleView(title: "Categories")
                    
                    CategoriesView(categories: $categories, properties: $allProperties)
                    
                    Divider()
                    
                    TitleView(title: "Recently Added Properties")
                    
                    PropertyListingView(properties: $properties)
                    
                    ViewAllView(properties: $allProperties)
                    
                }
            }
        }
        .onAppear {
            FirestoreManager.shared.getUserByUID(uid: AppUtility.shared.userId!) { _, _ in }
            
            FirestoreManager.shared.getAllProperties { result in
                switch result {
                case .success(let properties):
                    self.allProperties = properties
                    self.properties = properties.count > 4 ? Array(properties.prefix(4)) : properties
                    print("Successfully fetched properties:", properties)
                case .failure(let error):
                    print("Error fetching properties:", error.localizedDescription)
                }
            }
            
            FirestoreManager.shared.getCategoryNames { names, error in
                if let error = error {
                    print("Error fetching category names: \(error.localizedDescription)")
                } else if let names = names {
                    categories = names.map { CategoriesModel(text: $0) }
                    print("Category names: \(names)")
                } else {
                    print("Category document not found or 'name' field is not an array of strings.")
                }
            }
        }
    }
}

struct TitleView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            Spacer()
        }
    }
}


struct PropertyListingView: View {
    @Binding var properties: [Property]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(properties) { property in
                NavigationLink(destination: PropertyDetailScreen(property: property)) {
                    SecondListItemView(property: property)
                        .padding(4)
                }
            }
        }
        .padding()
    }
}

struct SecondListItemView: View {
    let property: Property
    @State private var imageURL: URL?
    var body: some View {
        VStack {
            WebImage(url: imageURL)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: (UIScreen.main.bounds.width / 2) - 20)
                .frame(height: 180)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(property.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.75))

                Text("Price: $\(property.price)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 4)
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onAppear {
            FirestoreManager.shared.getImageURL(for: property.imagePaths.first ?? "") { imageURL in
                if let imageURL = imageURL {
                    self.imageURL = imageURL
                } else { }
            }
        }
        
    }
}

struct CategoriesView: View {
    @Binding var categories: [CategoriesModel]
    @Binding var properties: [Property]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollView in
                HStack(spacing: 20) {
                    ForEach(categories) { category in
                        NavigationLink(destination: AllPropertiesListScreen(category: category, propertiesList: $properties)) {
                            ListItemView(category: category)
                                .id(category.id)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ListItemView: View {
    let category: CategoriesModel

    var body: some View {
        VStack {
            Text(category.text)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(16)
        .background(Color.blue.opacity(1))
        .cornerRadius(10)
    }
}

struct ViewAllView: View {
    @Binding var properties: [Property]
    var body: some View {
        NavigationLink {
            AllPropertiesListScreen(category: nil, propertiesList: $properties)
        } label: {
            Text("View All Properties")
                .frame(maxWidth: .infinity)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .padding([.horizontal, .bottom], 18)
    }
}

struct CategoriesModel: Identifiable, Hashable {
    let id = UUID()
    let text: String
}
