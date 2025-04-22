//
//  YouTubePlayerView.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 22/04/25.
//


import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    
    private let url: URL
    
    init?(videoID: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return nil }
        self.init(url: url)
    }
    
    init(url: URL) {
        self.url = url
    }
    
    // MARK: Functions

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubePlayerView

        init(_ parent: YouTubePlayerView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        }
    }
}