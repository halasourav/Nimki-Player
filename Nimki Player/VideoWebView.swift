import SwiftUI
import WebKit

struct VideoWebView: UIViewRepresentable {
    let videoURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: embedURL(from: videoURL))
        webView.load(request)
        webView.scrollView.isScrollEnabled = false
        webView.configuration.allowsInlineMediaPlayback = true
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // Convert to embed URL
    private func embedURL(from url: URL) -> URL {
        if url.host?.contains("youtube.com") == true || url.host?.contains("youtu.be") == true {
            if let videoID = extractYouTubeID(from: url) {
                return URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1")!
            }
        } else if url.host?.contains("vimeo.com") == true {
            let videoID = url.lastPathComponent
            return URL(string: "https://player.vimeo.com/video/\(videoID)?playsinline=1")!
        }
        return url
    }

    private func extractYouTubeID(from url: URL) -> String? {
        if url.host?.contains("youtu.be") == true {
            return url.lastPathComponent
        }
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        return queryItems?.first(where: { $0.name == "v" })?.value
    }
}
