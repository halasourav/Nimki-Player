//
//  VimeoSearchResponse.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 18/04/25.
//


import Foundation

struct VimeoSearchResponse: Codable {
    let data: [VimeoVideo]
    
    // Add these fields if they're in the response
    let total: Int?
    let page: Int?
    let perPage: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case total
        case page
        case perPage = "per_page"
    }
}

struct VimeoVideo: Codable {
    let name: String
    let link: String
    let pictures: VimeoPictures
    
    // Add optional fields that might be present
    let description: String?
    let duration: Int?
    let uri: String?
}

struct VimeoPictures: Codable {
    let sizes: [VimeoThumbnail]
    
    // Add optional fields
    let uri: String?
    let active: Bool?
}

struct VimeoThumbnail: Codable {
    let link: String
    let width: Int
    let height: Int
    
    // Add optional fields
    let linkWithPlayButton: String?
    
    enum CodingKeys: String, CodingKey {
        case link
        case width
        case height
        case linkWithPlayButton = "link_with_play_button"
    }
}
