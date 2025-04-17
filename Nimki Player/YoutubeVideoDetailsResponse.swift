//
//  YoutubeVideoDetailsResponse.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 17/04/25.
//


struct YoutubeVideoDetailsResponse: Codable {
    let items: [VideoDetailItem]
}

struct VideoDetailItem: Codable {
    let id: String
    let contentDetails: ContentDetails
}

struct ContentDetails: Codable {
    let duration: String
}
