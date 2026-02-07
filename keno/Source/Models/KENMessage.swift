import Foundation

struct KENMessage: Codable {
    let id: String
    let text: String
    let isMe: Bool
    let timestamp: Date
}
