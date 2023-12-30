//
//  HomeScreen.swift
//  RealtyPro
//


import SwiftUI

struct HomeScreen: View {
    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack(spacing: 4) {
                
                TitleView(title: "Categories")
                
                CategoriesView()
                
                TitleView(title: "Properties Near You")
                
                PropertyListingView()
                
                ViewAllView()
                
            }
        }
        .navigationBarTitle("Home", displayMode: .large)
    }
}

struct TitleView: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct PropertyListingView :View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                SecondListItemView(index: index)
                    .padding(4)
            }
        }
        .padding()
    }
}

struct CategoriesView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollView in
                HStack(spacing: 20) {
                    ForEach(0..<4) { index in
                        ListItemView(index: index)
                            .id(index)
                    }
                }
                .padding()
            }
        }
    }
}

struct ListItemView: View {
    let index: Int
    
    var body: some View {
        VStack {
            AsyncImageView(url: "https://picsum.photos/200")
            VStack(alignment: .leading, spacing: 10) {
                Text("Category \(index)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.75))
            }
            .padding(2)
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .frame(width: 200, height: 250)
        .cornerRadius(10)
    }
}


struct SecondListItemView: View {
    let index: Int
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
            } placeholder: {
                Color.blue.opacity(0.2)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Category \(index)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.75))
            }
            .padding(2)
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ViewAllView: View {
    var body: some View {
        NavigationLink {
            AllPropertiesListScreen()
        } label: {
            Text("View All Properties")
                .frame(maxWidth: .infinity)
                .bold()
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
    }
}

#Preview {
    HomeScreen()
}



