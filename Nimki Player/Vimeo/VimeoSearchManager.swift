//
//  VimeoSearchManager.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 18/04/25.
//


import Foundation

class VimeoSearchManager: ObservableObject {
    @Published var results: [VimeoVideoResult] = []
    
    // The access token needs to be fixed - there's an extra space at the beginning
    private let accessToken = "edd6f2d3757ff2c4f37f7b0e8e465221" // Removed the leading space
    
    func search(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // Vimeo API v3.4 endpoint
        let urlString = "https://api.vimeo.com/videos?query=\(encodedQuery)&per_page=10"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        print("Making Vimeo API request for query: \(query)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Log HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Vimeo API response status code: \(httpResponse.statusCode)")
            }
            
            if let error = error {
                print("Error fetching Vimeo data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from Vimeo API")
                return
            }
            
            // Print raw response for debugging
            if let responseStr = String(data: data, encoding: .utf8) {
                print("Vimeo response: \(responseStr.prefix(200))...") // Print first 200 chars
            }
            
            do {
                let decoded = try JSONDecoder().decode(VimeoSearchResponse.self, from: data)
                print("Successfully decoded Vimeo response with \(decoded.data.count) videos")
                
                DispatchQueue.main.async {
                    self.results = decoded.data.compactMap { video in
                        // Find the best thumbnail - prefer medium size
                        let sortedSizes = video.pictures.sizes.sorted { $0.width < $1.width }
                        let mediumIndex = min(sortedSizes.count - 1, max(sortedSizes.count / 2, 0))
                        guard let thumbnailURL = URL(string: sortedSizes[mediumIndex].link) else {
                            print("Invalid thumbnail URL for video: \(video.name)")
                            return nil
                        }
                        
                        guard let videoURL = URL(string: video.link) else {
                            print("Invalid video URL for video: \(video.name)")
                            return nil
                        }
                        
                        return VimeoVideoResult(
                            title: video.name,
                            thumbnailURL: thumbnailURL,
                            videoURL: videoURL,
                            source: "Vimeo"
                        )
                    }
                    
                    print("Updated Vimeo results count: \(self.results.count)")
                }
            } catch {
                print("Vimeo decoding error: \(error)")
                
                // Try to get more specific error information
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Key not found: \(key), context: \(context)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: \(type), context: \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type), context: \(context)")
                    default:
                        print("Other decoding error: \(decodingError)")
                    }
                }
            }
        }.resume()
    }
}
