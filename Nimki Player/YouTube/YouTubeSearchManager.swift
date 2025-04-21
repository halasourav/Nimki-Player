//
//  VideoSearchManager.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 17/04/25.
//
import Foundation
import UIKit

class YouTubeSearchManager: ObservableObject {
    @Published var results: [YouTubeVideoResult] = []
    
    private let apiKey = "AIzaSyA1JDxG-JFKoFIuhA0xTvF3mEAr6OnQVk8"
    
    func search(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=\(encodedQuery)&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                let items = decoded.items
                let videoIds = items.map { $0.id.videoId }.joined(separator: ",")

                self.fetchDurations(for: items, ids: videoIds)
            } catch {
                print("Search decode error: \(error)")
            }
        }.resume()
    }

    private func fetchDurations(for items: [YoutubeVideoItem], ids: String) {
        let detailsURL = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=\(ids)&key=\(apiKey)"
        guard let url = URL(string: detailsURL) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Details error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(YoutubeVideoDetailsResponse.self, from: data)
                let durationMap = Dictionary(uniqueKeysWithValues: decoded.items.map {
                    ($0.id, Self.parseDuration($0.contentDetails.duration))
                })

                DispatchQueue.main.async {
                    self.results = items.compactMap { item in
                        guard let duration = durationMap[item.id.videoId] else { return nil }
                        return YouTubeVideoResult(
                            title: item.snippet.title,
                            thumbnailURL: URL(string: item.snippet.thumbnails.medium.url)!,
                            videoURL: URL(string: "https://www.youtube.com/watch?v=\(item.id.videoId)")!,
                            source: "YouTube",
                            durationSeconds: duration
                        )
                    }
                }
            } catch {
                print("Duration decode error: \(error)")
            }
        }.resume()
    }

    private static func parseDuration(_ iso: String) -> Int {
        // Example formats: PT1M30S, PT45S, PT2M
        var seconds = 0

        let pattern = #"PT(?:(\d+)M)?(?:(\d+)S)?"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: iso, range: NSRange(iso.startIndex..., in: iso)) {
            
            let nsString = iso as NSString
            
            // Minutes capture group
            if match.range(at: 1).location != NSNotFound {
                let minutes = Int(nsString.substring(with: match.range(at: 1))) ?? 0
                seconds += minutes * 60
            }

            // Seconds capture group
            if match.range(at: 2).location != NSNotFound {
                let secs = Int(nsString.substring(with: match.range(at: 2))) ?? 0
                seconds += secs
            }
        }

        return seconds
    }

}

private extension String {
    func slice(from: String, to: String) -> String? {
        guard let fromRange = range(of: from) else { return nil }
        guard let toRange = range(of: to, range: fromRange.upperBound..<endIndex) else { return nil }
        return String(self[fromRange.upperBound..<toRange.lowerBound])
    }
}



