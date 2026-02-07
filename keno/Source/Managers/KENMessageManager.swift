import Foundation

// KENMessage moved to Source/Models/KENMessage.swift


class KENMessageManager {
    static let shared = KENMessageManager()
    
    private let kMessagesFile = "messages_data_v4.json"  // Changed to v4 to force re-seed with new user IDs
    // Key: My User ID, Value: [Target User ID: [Messages]]
    private var allMessages: [String: [String: [KENMessage]]] = [:]
    
    private init() {
        if let saved: [String: [String: [KENMessage]]] = KENPersistenceManager.shared.load(from: kMessagesFile) {
            self.allMessages = saved
        } else {
            // Initialize sample conversations
            seedSampleMessages()
        }
    }
    
    
    private func seedSampleMessages() {
        guard let currentUserId = KENAuthManager.shared.currentUser?.id else { return }
        
        // Sample conversations
        allMessages[currentUserId] = [
            "user_ReptileFan": [
                KENMessage(id: UUID().uuidString, text: "Hey! Nice gecko setup!", isMe: false, timestamp: Date().addingTimeInterval(-86400 * 2)),
                KENMessage(id: UUID().uuidString, text: "Thanks! Just finished setting it up 🦎", isMe: true, timestamp: Date().addingTimeInterval(-86400 * 2 + 300)),
                KENMessage(id: UUID().uuidString, text: "The terrarium looks amazing", isMe: false, timestamp: Date().addingTimeInterval(-86400 * 1))
            ],
            "user_Snake": [
                KENMessage(id: UUID().uuidString, text: "Love your video!", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 5)),
                KENMessage(id: UUID().uuidString, text: "Thank you so much! 😊", isMe: true, timestamp: Date().addingTimeInterval(-3600 * 4))
            ],
            "user_TurtlePower": [
                KENMessage(id: UUID().uuidString, text: "Hey, what substrate do you use?", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 12)),
                KENMessage(id: UUID().uuidString, text: "I use eco earth, works great!", isMe: true, timestamp: Date().addingTimeInterval(-3600 * 11)),
                KENMessage(id: UUID().uuidString, text: "Cool, I'll try that. Thanks!", isMe: false, timestamp: Date().addingTimeInterval(-3600 * 10))
            ]
        ]
        
        KENPersistenceManager.shared.save(allMessages, to: kMessagesFile)
    }
    
    func getMessages(for targetUserId: String) -> [KENMessage] {
        guard let myId = KENAuthManager.shared.currentUser?.id else { return [] }
        return allMessages[myId]?[targetUserId] ?? []
    }
    
    func sendMessage(text: String, to targetUserId: String) {
        guard let myId = KENAuthManager.shared.currentUser?.id else { return }
        
        let message = KENMessage(id: UUID().uuidString, text: text, isMe: true, timestamp: Date())
        
        if allMessages[myId] == nil {
            allMessages[myId] = [:]
        }
        
        if allMessages[myId]?[targetUserId] == nil {
            allMessages[myId]?[targetUserId] = []
        }
        
        allMessages[myId]?[targetUserId]?.append(message)
        
        // SAVE TO DISK
        KENPersistenceManager.shared.save(allMessages, to: kMessagesFile)
        
        NotificationCenter.default.post(name: NSNotification.Name("KENNewMessage"), object: nil, userInfo: ["chatId": targetUserId])
    }
    
    func getConversationUserIds() -> [String] {
        guard let myId = KENAuthManager.shared.currentUser?.id,
              let conversations = allMessages[myId] else { return [] }
        return Array(conversations.keys)
    }
    
    func deleteUserMessages(userId: String) {
        allMessages.removeValue(forKey: userId)
        KENPersistenceManager.shared.save(allMessages, to: kMessagesFile)
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
        KENPersistenceManager.shared.save(allMessages, to: kMessagesFile)
    }
}
