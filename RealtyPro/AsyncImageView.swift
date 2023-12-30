//
//  AsyncImageView.swift
//  RealtyPro
//

import SwiftUI

struct AsyncImageView: View {
    var url: String
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
            
        } placeholder: {
            Color.blue.opacity(0.2)
        }
        .frame(width: 200, height: 200)
    }
}

struct CustomImageView: View{
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10)
    }
}
