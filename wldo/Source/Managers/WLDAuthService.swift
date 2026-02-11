import Foundation
import UIKit

class WLDAuthService {
    static let shared = WLDAuthService()
    
    private let kIsLoggedInKey = "WLD_IsLoggedIn"
    private let kUserFile = "user_profile.json"
    
    private init() {
        self.currentUser = WLDStorageWorker.shared.load(from: kUserFile)
        if let blocked = UserDefaults.standard.stringArray(forKey: kBlockedUsersKey) {
            self.blockedUsers = Set(blocked)
        }
        
        // Initialize with default seed account
        if UserDefaults.standard.dictionary(forKey: kRegisteredUsersKey) == nil {
            UserDefaults.standard.set(["seed@wldo.com": "reptilefan_seed"], forKey: kRegisteredUsersKey)
        }
    }
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    private(set) var currentUser: WLDProfile?
    
    var currentUsername: String? {
        return currentUser?.username
    }
    
    private let kBlockedUsersKey = "WLD_BlockedUsers"
    private(set) var blockedUsers: Set<String> = []
    
    func ensureLoggedIn(on viewController: UIViewController, completion: @escaping () -> Void) {
        // ... (ensureLoggedIn code same)
        if isLoggedIn {
            completion()
        } else {
            let loginVC = WLDLoginView()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            loginVC.onLoginSuccess = {
                nav.dismiss(animated: true) {
                    completion()
                }
            }
            viewController.present(nav, animated: true)
        }
    }
    
    private let kRegisteredUsersKey = "WLD_RegisteredUsers"
    
    var registeredUsers: [String: String] {
        return UserDefaults.standard.dictionary(forKey: kRegisteredUsersKey) as? [String: String] ?? [:]
    }
    
    func isEmailRegistered(_ email: String) -> Bool {
        return registeredUsers[email.lowercased()] != nil
    }
    
    func getUserId(for email: String) -> String? {
        return registeredUsers[email.lowercased()]
    }
    
    func register(email: String, username: String) {
        var users = registeredUsers
        let newId = UUID().uuidString
        users[email.lowercased()] = newId
        UserDefaults.standard.set(users, forKey: kRegisteredUsersKey)
        
        // Always generate a fresh ID for registration
        login(id: newId, username: username, email: email)
    }
    
    func login(id: String, username: String, email: String) {
        let user = WLDProfile(
            id: id,
            username: username,
            email: email,
            avatarURL: "avatar_\(username.lowercased())",  // Local avatar asset
            bio: "New reptile enthusiast 🦎"
        )
        self.currentUser = user
        UserDefaults.standard.set(true, forKey: kIsLoggedInKey)
        WLDStorageWorker.shared.save(user, to: kUserFile)
    }
    
    func logout() {
        self.currentUser = nil
        UserDefaults.standard.set(false, forKey: kIsLoggedInKey)
        // Physically delete the user file for a clean state
        WLDStorageWorker.shared.deleteFile(name: kUserFile)
    }
    
    func deleteAccount() {
        guard let email = currentUser?.email.lowercased(),
              let userId = currentUser?.id else { return }
        
        // 1. Remove from registered users mapping immediately
        var users = registeredUsers
        users.removeValue(forKey: email)
        UserDefaults.standard.set(users, forKey: kRegisteredUsersKey)
        
        // 2. Delete all posts created by this user and associated media files
        WLDFeedController.shared.deleteUserPosts(userId: userId)
        
        // 3. Delete all message conversations (sent and received)
        WLDChatHandler.shared.deleteAllConversationsWithUser(userId: userId)
        
        // 4. Perform deep cleanup and logout
        logout()
    }
    
    func blockUser(username: String) {
        blockedUsers.insert(username)
        UserDefaults.standard.set(Array(blockedUsers), forKey: kBlockedUsersKey)
        NotificationCenter.default.post(name: NSNotification.Name("WLDProfileBlocked"), object: nil, userInfo: ["username": username])
    }
    
    func isUserBlocked(_ username: String) -> Bool {
        return blockedUsers.contains(username)
    }
}
