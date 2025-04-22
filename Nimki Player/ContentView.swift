//
//  ContentView.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 10/04/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var selectedPlatform: VideoPlatform = .all
    @StateObject private var locationManager = LocationManager()
    @StateObject private var youtubeSearchManager = YouTubeSearchManager()
    @StateObject private var vimeoSearchManager = VimeoSearchManager()
    @State private var searchText = ""
    @State private var selectedVideoURL: URL?

    private var youtubeVideoResults: [YouTubeVideoResult] {
        youtubeSearchManager.results.filter { !isShort(title: $0.title, url: $0.videoURL, duration: $0.durationSeconds) }
    }

    private var youtubeShortResults: [YouTubeVideoResult] {
        youtubeSearchManager.results.filter { isShort(title: $0.title, url: $0.videoURL, duration: $0.durationSeconds) }
    }

    var body: some View {
        ZStack {
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

                // MARK: Search Bar + Filters
                VStack(alignment: .leading, spacing: 10) {
                    SearchBarView(text: $searchText) {
                        youtubeSearchManager.search(query: searchText)
                        vimeoSearchManager.search(query: searchText)
                    }

                    HStack {
                        filterButton(for: .all, label: "All", color: .blue)
                        filterButton(for: .youtube, label: "YouTube", color: .red)
                        filterButton(for: .vimeo, label: "Vimeo", color: .purple)
                    }
                    .padding(.horizontal)
                }

                // MARK: Video Results
                if youtubeSearchManager.results.isEmpty && vimeoSearchManager.results.isEmpty {
                    Spacer()
                    Text("No results")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                if (selectedPlatform == .all || selectedPlatform == .youtube),
                                   !youtubeSearchManager.results.isEmpty {
                                    Text("YouTube")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                        .padding(.top, 8)

                                    if !youtubeVideoResults.isEmpty {
                                        Text("Videos")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                            .padding(.top, 4)

                                        ForEach(youtubeVideoResults) { result in
                                            youTubevideoResultView(result)
                                        }
                                    }

                                    if !youtubeShortResults.isEmpty {
                                        Text("Shorts")
                                            .font(.callout)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                            .padding(.top, 8)

                                        ForEach(youtubeShortResults) { result in
                                            youTubevideoResultView(result)
                                        }
                                    }
                                }

                                if (selectedPlatform == .all || selectedPlatform == .vimeo),
                                   !vimeoSearchManager.results.isEmpty {
                                    Text("Vimeo")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.horizontal)
                                        .padding(.top, 16)

                                    ForEach(vimeoSearchManager.results) { result in
                                        vimeoVideoResultView(result)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width)
                    }
                }
            }
        }
        .sheet(item: $selectedVideoURL) { url in
            SafariView(url: url)
        }
    }

    // MARK: - Helper Views

    private func filterButton(for platform: VideoPlatform, label: String, color: Color) -> some View {
        Button(action: {
            selectedPlatform = platform
        }) {
            Text(label)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(selectedPlatform == platform ? color.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }

    private func isShort(title: String, url: URL? = nil, duration: Int? = nil) -> Bool {
        let lowercasedTitle = title.lowercased()
        if lowercasedTitle.contains("#short") ||
            lowercasedTitle.contains("#shorts") {
            return true
        }

        if let urlString = url?.absoluteString.lowercased(),
            urlString.contains("youtube.com/shorts") || urlString.contains("youtu.be/shorts") {
            return true
        }

        if let duration = duration, duration <= 60 {
            return true
        }

        return false
    }

    //MARK: Play Video
    @ViewBuilder
    private func youTubevideoResultView(_ result: YouTubeVideoResult) -> some View {
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
        .padding(.horizontal)
        .onTapGesture {
            selectedVideoURL = result.videoURL
        }
    }

    @ViewBuilder
    private func vimeoVideoResultView(_ result: VimeoVideoResult) -> some View {
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
        .padding(.horizontal)
        .onTapGesture {
            selectedVideoURL = result.videoURL
        }
    }

    enum VideoPlatform: String {
        case youtube = "YouTube"
        case vimeo = "Vimeo"
        case all = "All"
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

