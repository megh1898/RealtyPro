//
//  SearchLocationsScreen.swift
//  RealtyPro
//


import SwiftUI

struct SearchLocationsScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ContentViewModel()
    @Binding var location: LocalSearchViewData?
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Search", text: $viewModel.cityText)
            Divider()
            Text("Results")
                .font(.title)
            List(viewModel.viewData) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                    Text(item.subtitle)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    location = item
                    dismiss()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .ignoresSafeArea(edges: .bottom)
    }
}
