import Foundation

// WLDChatItem moved to Source/Models/WLDChatItem.swift


class WLDChatHandler {
    static let shared = WLDChatHandler()
    
    private let kMessagesFile = "messages_data_v4.json"  // Changed to v4 to force re-seed with new user IDs
    // Key: My User ID, Value: [Target User ID: [Messages]]
    private var allMessages: [String: [String: [WLDChatItem]]] = [:]
    
    private init() {
        if let saved: [String: [String: [WLDChatItem]]] = WLDStorageWorker.shared.load(from: kMessagesFile) {
            self.allMessages = saved
        } else {
            // Initialize sample conversations
            seedSampleMessages()
        }
    }
    
    
    private func seedSampleMessages() {
        guard let currentUserId = WLDAuthService.shared.currentUser?.id else { return }
        
        // Sample conversations
        allMessages[currentUserId] = [
            "user_ReptileFan": [
                WLDChatItem(id: UUID().uuidString, text: "Hey! Nice gecko setup!", isMe: false, timestamp: Date().addingTimeInterval(-86400 * 2)),
                WLDChatItem(id: UUID().uuidString, text: "Thanks! Just finished setting it up 🦎", isMe: true, timestamp: Date().addingTimeInterval(-86400 * 2 + 300)),
                WLDChatItem(id: UUID().uuidString, text: "The terrarium looks amazing", isMe: false, timestamp: Date().addingTimeInterval(-86400 * 1))
            ],
            "user_Snake": [
                WLDChatItem(id: UUID().uuidString, text: "Love your video!", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 5)),
                WLDChatItem(id: UUID().uuidString, text: "Thank you so much! 😊", isMe: true, timestamp: Date().addingTimeInterval(-3600 * 4))
            ],
            "user_TurtlePower": [
                WLDChatItem(id: UUID().uuidString, text: "Hey, what substrate do you use?", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 12)),
                WLDChatItem(id: UUID().uuidString, text: "I use eco earth, works great!", isMe: true, timestamp: Date().addingTimeInterval(-3600 * 11)),
                WLDChatItem(id: UUID().uuidString, text: "Cool, I'll try that. Thanks!", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 10))
            ]
        ]
        
        WLDStorageWorker.shared.save(allMessages, to: kMessagesFile)
    }
    
    func getMessages(for targetUserId: String) -> [WLDChatItem] {
        guard let myId = WLDAuthService.shared.currentUser?.id else { return [] }
        return allMessages[myId]?[targetUserId] ?? []
    }
    
    func sendMessage(text: String, to targetUserId: String) {
        guard let myId = WLDAuthService.shared.currentUser?.id else { return }
        
        let message = WLDChatItem(id: UUID().uuidString, text: text, isMe: true, timestamp: Date())
        
        if allMessages[myId] == nil {
            allMessages[myId] = [:]
        }
        
        if allMessages[myId]?[targetUserId] == nil {
            allMessages[myId]?[targetUserId] = []
        }
        
        allMessages[myId]?[targetUserId]?.append(message)
        
        // SAVE TO DISK
        WLDStorageWorker.shared.save(allMessages, to: kMessagesFile)
        
        NotificationCenter.default.post(name: NSNotification.Name("WLDNewMessage"), object: nil, userInfo: ["chatId": targetUserId])
    }
    
    func getConversationUserIds() -> [String] {
        guard let myId = WLDAuthService.shared.currentUser?.id,
              let conversations = allMessages[myId] else { return [] }
        return Array(conversations.keys)
    }
    
    func deleteUserMessages(userId: String) {
        allMessages.removeValue(forKey: userId)
        WLDStorageWorker.shared.save(allMessages, to: kMessagesFile)
    }
    
    func deleteAllConversationsWithUser(userId: String) {
        // 1. Delete all messages sent by this user
        allMessages.removeValue(forKey: userId)
        
        // 2. Delete all messages sent TO this user from other users
        for (otherUserId, var conversations) in allMessages {
            // Remove conversation with the deleted user
            if conversations[userId] != nil {
                conversations.removeValue(forKey: userId)
                allMessages[otherUserId] = conversations
            }
        }
        
        // 3. Save to disk
        WLDStorageWorker.shared.save(allMessages, to: kMessagesFile)
    }
}
