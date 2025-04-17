//
//  YoutubeSearchResponse.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 17/04/25.
//


import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [YoutubeVideoItem]
}

struct YoutubeVideoItem: Codable {
    let id: VideoID
    let snippet: Snippet
}

struct VideoID: Codable {
    let videoId: String
}

struct Snippet: Codable {
    let title: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
    let medium: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
}
