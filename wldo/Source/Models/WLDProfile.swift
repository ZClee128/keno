import Foundation

struct WLDProfile: Codable, Hashable {
    let id: String
    let username: String
    let email: String
    let avatarURL: String
    var bio: String
}
