//
//  VideoSearchManager.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 17/04/25.
//
import Foundation
import UIKit

class VideoSearchManager: ObservableObject {
    @Published var results: [VideoResult] = []
    
    private let apiKey = "AIzaSyA1JDxG-JFKoFIuhA0xTvF3mEAr6OnQVk8"

    func search(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=\(encodedQuery)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching YouTube data: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.results = decoded.items.map { item in
                        VideoResult(
                            title: item.snippet.title,
                            thumbnailURL: URL(string: item.snippet.thumbnails.medium.url)!,
                            videoURL: URL(string: "https://www.youtube.com/watch?v=\(item.id.videoId)")!,
                            source: "YouTube"
                        )
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }

        }.resume()
    }
}


