import Foundation

struct WLDChatItem: Codable {
    let id: String
    let text: String
    let isMe: Bool
    let timestamp: Date
}
