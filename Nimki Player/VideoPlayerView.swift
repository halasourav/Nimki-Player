//
//  VideoPlayerView.swift
//  Nimki Player
//
//  Created by Sourav Bhattacharjee on 21/04/25.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .edgesIgnoringSafeArea(.all)
            .onDisappear {
                // Stop playback when dismissed
                AVPlayer(url: videoURL).pause()
            }
    }
}
