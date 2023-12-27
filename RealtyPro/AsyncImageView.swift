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
