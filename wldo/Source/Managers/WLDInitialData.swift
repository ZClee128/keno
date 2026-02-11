import Foundation

class WLDInitialData {
    static func getPosts() -> [WLDArticle] {
        var posts: [WLDArticle] = []
        
        // --- 1. High Quality Manual Posts (Videos) ---
        let defaultImg1 = "resource_img_01.jpg"
        let defaultVid1 = "resource_vid_01.mp4"
        let defaultImg2 = "resource_img_02.jpg"
        let defaultVid2 = "resource_vid_02.mp4"
        let manualPosts = [
            WLDArticle(
                id: "1",
                userId: "user_geckofan",
                username: "GeckoFan",
                userAvatarURL: "avatar_reptilefan",  // Local asset
                postImageURL: defaultImg1,
                caption: "My first video post on Keno! 🦎 #leopardgecko #reptiles #video",
                likes: 124,
                comments: 12,
                timestamp: "Just now",
                videoName: defaultVid1,
                location: "Reptile Room",
                tags: ["Gecko", "Video"],
                isLiked: false
            ),
            WLDArticle(
                id: "2",
                userId: "reptilefan_seed",
                username: "ReptileFan",
                userAvatarURL: "avatar_reptilefan",  // Local asset
                postImageURL: "placeholder_reptile_1",  // Local asset
                caption: "Beautiful sunset with my gecko! 🌅🦎",
                likes: 89,
                comments: 7,
                timestamp: "2h ago",
                videoName: nil,
                location: "Home",
                tags: ["Sunset", "Gecko"],
                isLiked: false
            ),
            WLDArticle(
                id: "3",
                userId: "reptilefan_seed",
                username: "ReptileFan",
                userAvatarURL: "avatar_reptilefan",  // Local asset
                postImageURL: "placeholder_reptile_2",  // Local asset
                caption: "New terrarium setup is complete! 🌿",
                likes: 156,
                comments: 23,
                timestamp: "1d ago",
                videoName: nil,
                location: "Reptile Room",
                tags: ["Terrarium", "Setup"],
                isLiked: false
            ),
            WLDArticle(
                id: "4",
                userId: "reptilefan_seed",
                username: "ReptileFan",
                userAvatarURL: "avatar_reptilefan",  // Local asset
                postImageURL: "placeholder_reptile_3",  // Local asset
                caption: "Feeding time! 🦗",
                likes: 67,
                comments: 5,
                timestamp: "2d ago",
                videoName: nil,
                location: "Home",
                tags: ["Feeding"],
                isLiked: false
            ),
            WLDArticle(
                id: "5",
                userId: "reptilefan_seed",
                username: "ReptileFan",
                userAvatarURL: "avatar_reptilefan",  // Local asset
                postImageURL: defaultImg2,
                caption: "Look at those eyes! 👀✨",
                likes: 203,
                comments: 15,
                timestamp: "3d ago",
                videoName: nil,
                location: "Home",
                tags: ["Eyes", "Cute"],
                isLiked: false
            ),
            WLDArticle(
                id: "2",
                userId: "user_snake",
                username: "SnakeWhisperer",
                userAvatarURL: "avatar_snake",  // Local asset
                postImageURL: "2.jpg",
                caption: "New jungle setup for the python! 🐍 #ballpython #enclosure",
                likes: 89,
                comments: 34,
                timestamp: "5h ago",
                videoName: "2.mp4",
                location: "Jungle Habitat",
                tags: ["Python", "Enclosure"],
                isLiked: true
            )
        ]
        posts.append(contentsOf: manualPosts)
        
        // --- 2. Dynamic Generation (using local placeholders) ---
        
        let usernames = ["ChameleonCham", "TurtlePower", "BeardedBuddy", "IguanaIggy", "FrogPrince", "DinoDan", "ScalySue", "KoboldKeeper", "ViperVicky", "GatorGary", "KomodoKing", "AxolotlAlly"]
        
        let locations = ["Madagascar", "Amazon Rainforest", "Sahara Desert", "Florida Everglades", "Galapagos", "Komodo Island", "Home Terrarium", "Reptile Expo", "Zoo Exhibit", "Backyard Pond"]
        
        let captions = [
            "Just hanging out in the sun. ☀️",
            "Feeding time is the best time! 🦗",
            "Look at these colors! 🎨",
            "Sleepy head today. 💤",
            "New setup for the enclosure. thoughts? 🌿",
            "Reviewing the new heat lamp. 🔥",
            "My little dinosaur. 🦖",
            "Can't believe how big they're getting!",
            "Shedding season again... 🐍",
            "Found this little guy in the garden.",
            "Reptile love is real love. ❤️"
        ]
        
        // Use local placeholders instead of external URLs
        // Use local placeholders instead of external URLs
        let localPlaceholders = ["resource_img_01.jpg", "resource_vid_01.mp4", "resource_img_02.jpg", "resource_vid_02.mp4", "2.jpg", "placeholder_reptile_1", "placeholder_reptile_2", "placeholder_reptile_3"]
        
        for i in 3...50 {
            let user = usernames.randomElement()!
            let location = locations.randomElement()!
            let caption = captions.randomElement()!
            let placeholderImage = localPlaceholders.randomElement()!
            let likes = Int.random(in: 10...5000)
            let comments = Int.random(in: 0...100)
            
            let post = WLDArticle(
                id: "\(i)",
                userId: "user_\(user)",
                username: user,
                userAvatarURL: "avatar_\(user.lowercased())",  // Local avatar
                postImageURL: placeholderImage,  // Local placeholder
                caption: caption,
                likes: likes,
                comments: comments,
                timestamp: "\(Int.random(in: 1...23))h ago",
                videoName: nil,
                location: location,
                tags: ["#Reptile", "#Nature"],
                isLiked: Bool.random()
            )
            posts.append(post)
        }
        
        return posts
    }
}
