import Foundation

struct KENPost: Hashable, Sendable, Codable {
    let id: String
    let userId: String
    let username: String
    let userAvatarURL: String
    let postImageURL: String
    let caption: String
    let likes: Int
    let comments: Int
    let timestamp: String
    
    // New Fields for Fizzr Port
    let videoName: String? // Local file name e.g. "1.mp4"
    let location: String?
    let tags: [String]
    var isLiked: Bool
}
