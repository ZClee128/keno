import Foundation
import UIKit

class KENPostManager {
    static let shared = KENPostManager()
    
    private let kPostsFile = "posts_data.json"
    private var posts: [KENPost] = []
    
    private init() {
        // Load from disk
        let savedPosts: [KENPost] = KENPersistenceManager.shared.load(from: kPostsFile) ?? []
        let seededPosts = KENDataSeeder.getPosts()
        
        // Seeded posts take priority for matching IDs to allow updates
        var merged = seededPosts
        let seededIds = Set(seededPosts.map { $0.id })
        
        for post in savedPosts {
            if !seededIds.contains(post.id) {
                merged.append(post)
            }
        }
        
        self.posts = merged
    }
    
    func getAllPosts() -> [KENPost] {
        // Filter out blocked users
        let blocked = KENAuthManager.shared.blockedUsers
        let filtered = posts.filter { !blocked.contains($0.username) }
        
        // Prioritize videos: videos first, then others. Maintain original order within groups.
        return filtered.sorted { (p1, p2) -> Bool in
            let v1 = p1.videoName != nil
            let v2 = p2.videoName != nil
            if v1 == v2 { return false } // Keep relative order
            return v1 && !v2 // v1 comes first if it's a video and v2 isn't
        }
    }
    
    func addPost(image: UIImage, caption: String) {
        let user = KENAuthManager.shared.currentUser
        
        let imageFileName = "post_\(UUID().uuidString).jpg"
        let imagePath = KENPersistenceManager.shared.saveImage(image, fileName: imageFileName) ?? ""
        
        let newPost = KENPost(
            id: UUID().uuidString,
            userId: user?.id ?? "Guest",
            username: user?.username ?? "Me",
            userAvatarURL: user?.avatarURL ?? "avatar_default",  // Local default avatar
            postImageURL: imagePath, 
            caption: caption,
            likes: 0,
            comments: 0,
            timestamp: "Just now",
            videoName: nil,
            location: "Unknown",
            tags: [],
            isLiked: false
        )
        posts.insert(newPost, at: 0)
        
        // SAVE TO DISK
        KENPersistenceManager.shared.save(posts, to: kPostsFile)
        
        // Notify
        NotificationCenter.default.post(name: NSNotification.Name("KENNewPostAdded"), object: nil)
    }
    
    func deleteUserPosts(userId: String) {
        // Find all posts belonging to this user
        let userPosts = posts.filter { $0.userId == userId }
        
        // Delete associated media files for each post
        for post in userPosts {
            // Delete post image if it's a local file (not a URL)
            if !post.postImageURL.hasPrefix("http") && !post.postImageURL.isEmpty {
                KENPersistenceManager.shared.deleteFile(name: post.postImageURL)
            }
            
            // Delete video file if it exists
            if let videoName = post.videoName, !videoName.isEmpty {
                KENPersistenceManager.shared.deleteFile(name: videoName)
            }
        }
        
        // Remove posts from array
        posts.removeAll { $0.userId == userId }
        
        // Save updated posts to disk
        KENPersistenceManager.shared.save(posts, to: kPostsFile)
        
        // Notify UI to refresh
        NotificationCenter.default.post(name: NSNotification.Name("KENNewPostAdded"), object: nil)
    }
}

