//
//  CollectionsScreen.swift
//  RealtyPro
//

import SwiftUI

struct CollectionsScreen: View {
    var body: some View {
        NavigationView {
            ScrollView {
                CategoriesUpdatedListingView()
                    .navigationBarTitle("Browse by Category")
            }
        }
    }
}

struct CategoriesUpdatedListingView: View {
    var data = CategoriesUpdatedModel.sampleData
    @State private var properties = [Property]()
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(data) { category in
                let _category = CategoriesModel(text: category.name)
                NavigationLink(destination: AllPropertiesListScreen(category: _category, propertiesList: $properties)) {
                    CategoryView(category: category)
                }
            }
        }
        .padding()
        .onAppear {
            FirestoreManager.shared.getAllProperties { result in
                switch result {
                case .success(let properties):
                    self.properties = properties
                    print("Successfully fetched properties:", properties)
                case .failure(let error):
                    print("Error fetching properties:", error.localizedDescription)
                }
            }
        }
    }
}

struct CategoryView: View {
    let category: CategoriesUpdatedModel
    @State private var imageURL: URL?
    var body: some View {
        VStack {
            category.image
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: (UIScreen.main.bounds.width / 2) - 20)
                .frame(height: 180)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.75))
                    .frame(height: 30)
                    .padding(.bottom, 8)
            }
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}


#Preview {
    CollectionsScreen()
}

struct CategoriesUpdatedModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let image: Image

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CategoriesUpdatedModel, rhs: CategoriesUpdatedModel) -> Bool {
        return lhs.id == rhs.id
    }

    static var sampleData: [CategoriesUpdatedModel] {
        return [
            CategoriesUpdatedModel(name: "Recently Sold", image: Image("1")),
            CategoriesUpdatedModel(name: "For Rent", image: Image("2")),
            CategoriesUpdatedModel(name: "Open Houses", image: Image("3")),
            CategoriesUpdatedModel(name: "Condos", image: Image("4")),
            CategoriesUpdatedModel(name: "Studio", image: Image("5")),
            CategoriesUpdatedModel(name: "New Homes", image: Image("6")),
        ]
    }
}
