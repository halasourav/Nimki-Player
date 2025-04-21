//
//  VideoResult.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 17/04/25.
//
import Foundation

struct YouTubeVideoResult: Equatable, Identifiable {
    let id = UUID()
    let title: String
    let thumbnailURL: URL
    let videoURL: URL
    let source: String  // e.g. "YouTube", "Vimeo"
    let durationSeconds: Int
}

struct VimeoVideoResult: Equatable, Identifiable {
    let id = UUID()
    let title: String
    let thumbnailURL: URL
    let videoURL: URL
    let source: String  // e.g. "YouTube", "Vimeo"
}
