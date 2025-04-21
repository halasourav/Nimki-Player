import Foundation

class VimeoSearchManager: ObservableObject {
    @Published var results: [VideoResult] = []
    
    // You'll need to register for Vimeo Developer API access
    private let accessToken = "YOUR_VIMEO_ACCESS_TOKEN" // Replace with your actual token
    
    func search(query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // Vimeo API v3.4 endpoint
        let urlString = "https://api.vimeo.com/videos?query=\(encodedQuery)&per_page=10"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching Vimeo data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(VimeoSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.results = decoded.data.map { video in
                        let thumbnailURL = URL(string: video.pictures.sizes.last?.link ?? "")!
                        let videoURL = URL(string: video.link)!
                        
                        return VideoResult(
                            title: video.name,
                            thumbnailURL: thumbnailURL,
                            videoURL: videoURL,
                            source: "Vimeo"
                        )
                    }
                }
            } catch {
                print("Vimeo decoding error: \(error)")
            }
        }.resume()
    }
}