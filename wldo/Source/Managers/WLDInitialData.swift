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
                userId: "user_coffeelover",
                username: "CoffeeLover",
                userAvatarURL: "avatar_cafehopper",
                postImageURL: defaultImg1,
                caption: "Morning brew to start the day right ☕️✨ #coffee #morningroutine #lifestyle",
                likes: 124,
                comments: 12,
                timestamp: "Just now",
                videoName: defaultVid1,
                location: "Cozy Cafe",
                tags: ["Coffee", "Lifestyle"],
                isLiked: false
            ),
            WLDArticle(
                id: "2",
                userId: "cozyhome_seed",
                username: "CozyHome",
                userAvatarURL: "avatar_cozycorner",
                postImageURL: "placeholder_reptile_1",  // Local asset
                caption: "Golden hour streaming into the living room 🌅🛋️",
                likes: 89,
                comments: 7,
                timestamp: "2h ago",
                videoName: nil,
                location: "Home",
                tags: ["Decor", "GoldenHour"],
                isLiked: false
            ),
            WLDArticle(
                id: "3",
                userId: "yogalife_seed",
                username: "YogaLife",
                userAvatarURL: "avatar_yogadaily",
                postImageURL: "placeholder_reptile_2",  // Local asset
                caption: "Sunday morning stretch and meditation 🌿🧘‍♀️",
                likes: 156,
                comments: 23,
                timestamp: "1d ago",
                videoName: nil,
                location: "Studio",
                tags: ["Yoga", "Wellness"],
                isLiked: false
            ),
            WLDArticle(
                id: "4",
                userId: "reading_seed",
                username: "BookWorm",
                userAvatarURL: "avatar_booklover",
                postImageURL: "placeholder_reptile_3",  // Local asset
                caption: "Current read: lost in another world 📖✨",
                likes: 67,
                comments: 5,
                timestamp: "2d ago",
                videoName: nil,
                location: "Home Library",
                tags: ["Reading", "Books"],
                isLiked: false
            ),
            WLDArticle(
                id: "5",
                userId: "wellness_seed",
                username: "WellnessJourney",
                userAvatarURL: "avatar_healthyeats",
                postImageURL: defaultImg2,
                caption: "Nourishing lunch bowl! 🥗🥑",
                likes: 203,
                comments: 15,
                timestamp: "3d ago",
                videoName: nil,
                location: "Kitchen",
                tags: ["Healthy", "Food"],
                isLiked: false
            ),
            WLDArticle(
                id: "2",
                userId: "user_aesthetic",
                username: "AestheticVibes",
                userAvatarURL: "avatar_warmaesthetic",  // Local asset
                postImageURL: "placeholder_reptile_1",
                caption: "New desk setup for productivity! 💻☕️ #workspace #desksetup",
                likes: 89,
                comments: 34,
                timestamp: "5h ago",
                videoName: nil,
                location: "Home Office",
                tags: ["Workspace", "Productivity"],
                isLiked: true
            )
        ]
        posts.append(contentsOf: manualPosts)
        
        // --- 2. Dynamic Generation (using local placeholders) ---
        
        let usernames = ["CafeHopper", "YogaDaily", "PlantParent", "BookLover", "MinimalistLife", "HealthyEats", "CozyCorner", "TravelDiaries", "WarmAesthetic", "SlowLiving", "MindfulMoments", "UrbanOasis"]
        
        let locations = ["Local Coffee Shop", "City Apartment", "Yoga Studio", "Farmer's Market", "Botanical Garden", "Downtown Bookstore", "Cozy Bedroom", "Quiet Park", "Art Museum", "Sunny Balcony"]
        
        let captions = [
            "Just enjoying the slow morning. ☀️☕️",
            "Perfect day for a matcha latte! 🍵",
            "Loving this new decor piece ✨",
            "Resting and recharging. 💤",
            "Rearranged the plants today! 🪴",
            "Trying out a new healthy recipe. 🥗",
            "Weekend vibes. 📖",
            "Can't believe how peaceful it is here.",
            "Time for self-care... 🛁",
            "Found this cute spot in the city.",
            "Romanticizing my life. ❤️"
        ]
        
        // Use local placeholders instead of external URLs
        let localPlaceholders = ["placeholder_reptile_1", "placeholder_reptile_2", "placeholder_reptile_3"]
        
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
                tags: ["#Lifestyle", "#Cozy"],
                isLiked: Bool.random()
            )
            posts.append(post)
        }
        
        return posts
    }
}
