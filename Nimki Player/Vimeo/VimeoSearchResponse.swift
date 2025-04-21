import Foundation

struct VimeoSearchResponse: Codable {
    let data: [VimeoVideo]
}

struct VimeoVideo: Codable {
    let name: String
    let link: String
    let pictures: VimeoPictures
}

struct VimeoPictures: Codable {
    let sizes: [VimeoThumbnail]
}

struct VimeoThumbnail: Codable {
    let link: String
    let width: Int
    let height: Int
}