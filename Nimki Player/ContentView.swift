//
//  ContentView.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 10/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchManager = VideoSearchManager()
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: Location
            HStack {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.blue)
                Text(locationManager.city)
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // MARK: Search Bar
            SearchBarView(text: $searchText) {
                searchManager.search(query: searchText)
            }
            
            // MARK: Results
            if searchManager.results.isEmpty {
                Spacer()
                Text("No results")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                Spacer()
            } else {
                List(searchManager.results) { result in
                    HStack {
                        AsyncImage(url: result.thumbnailURL) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 100, height: 56)
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.source)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.open(result.videoURL)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
