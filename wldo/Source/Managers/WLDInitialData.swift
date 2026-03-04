import Foundation

class WLDInitialData {
    static func getPosts() -> [WLDArticle] {
        var posts: [WLDArticle] = []
        
        // --- 1. High Quality Manual Posts (Videos) ---
        let defaultImg1 = "cosplay_1.jpeg"
        let defaultVid1 = "cosplay_1.mp4"
        let defaultImg2 = "cosplay_2.jpeg"
        let defaultVid2 = "cosplay_2.mp4"
        let manualPosts = [
            WLDArticle(
                id: "1",
                userId: "user_1",
                username: "System",
                userAvatarURL: "",
                postImageURL: defaultImg1,
                caption: "New Cyberpunk 2077 Edgerunners Lucy cosplay shoot! The neon lighting setup was crazy. 📸✨ #cyberpunk #lucycosplay #neon",
                likes: 1240,
                comments: 120,
                timestamp: "Just now",
                videoName: defaultVid1,
                location: "Neo Tokyo Studio",
                tags: ["Cyberpunk", "Lucy", "Neon"],
                isLiked: false
            ),
            WLDArticle(
                id: "2",
                userId: "user_2",
                username: "System",
                userAvatarURL: "",
                postImageURL: defaultImg2,
                caption: "Finally finished the EVA-01 armor details! 100+ hours of foam crafting. 👗✨",
                likes: 890,
                comments: 75,
                timestamp: "2h ago",
                videoName: defaultVid2,
                location: "Comic Con",
                tags: ["EVA", "Armor Making"],
                isLiked: false
            ),
            WLDArticle(
                id: "3",
                userId: "user_3",
                username: "System",
                userAvatarURL: "",
                postImageURL: "new_cosplay_04",  // Local asset
                caption: "Genshin Impact Raiden Shogun photoshoot previews. The sword prop looks amazing in the dark! ⚡️💜",
                likes: 1560,
                comments: 230,
                timestamp: "1d ago",
                videoName: nil,
                location: "Inazuma Set",
                tags: ["Genshin", "RaidenShogun"],
                isLiked: false
            ),
            WLDArticle(
                id: "4",
                userId: "user_4",
                username: "System",
                userAvatarURL: "",
                postImageURL: "new_cosplay_05",  // Local asset
                caption: "Frieren at the Funeral setup. Magic staff made using 3D printing and resin casting. 🪄✨",
                likes: 670,
                comments: 55,
                timestamp: "2d ago",
                videoName: nil,
                location: "Magic Forest",
                tags: ["Frieren", "Props"],
                isLiked: false
            ),
            WLDArticle(
                id: "5",
                userId: "user_5",
                username: "System",
                userAvatarURL: "",
                postImageURL: defaultImg2,
                caption: "Jujutsu Kaisen Gojo Satoru casual street snap. 🕶️👟",
                likes: 2030,
                comments: 150,
                timestamp: "3d ago",
                videoName: nil,
                location: "Shibuya",
                tags: ["JJK", "GojoSatoru"],
                isLiked: false
            ),
            WLDArticle(
                id: "6",
                userId: "user_6",
                username: "System",
                userAvatarURL: "",  // Local asset
                postImageURL: "new_cosplay_06",
                caption: "Nier Automata 2B abandoned factory location shoot! 📸✨ #nier #2b",
                likes: 890,
                comments: 340,
                timestamp: "5h ago",
                videoName: nil,
                location: "Factory Ruins",
                tags: ["NierAutomata", "2B"],
                isLiked: true
            )
        ]
        posts.append(contentsOf: manualPosts)
        
        // --- 2. Dynamic Generation (using local placeholders) ---
        
        let usernames = ["System"] // Not displayed anymore
        
        let locations = ["Anime Expo", "Comiket", "Studio A", "Abandoned Factory", "Forest Park", "Neo City", "Cyberpunk Alley", "School Rooftop", "Shrine Set", "Gothic Castle"]
        
        let captions = [
            "Just finished styling the wig! 💇‍♀️✂️",
            "Armor test fit before the con. 🛡️",
            "Editing these raw photos took forever but totally worth it. 📸✨",
            "This fabric looks magical under stadium lights. ✨",
            "Behind the scenes at today's Genshin shoot. 🎬",
            "Sword prop is finally fully 3D printed and sanded. ⚔️",
            "Makeup test for Makima! 💄",
            "Found the perfect ruins for this Nier shoot. ⚙️",
            "Can't wait to debut this at Anime Expo! 🎉",
            "Who's your favorite character from this season? 🌸",
            "Action pose practice. The cape flow is perfect! 🦇"
        ]
        
        // Use specific local placeholders for the remaining 7 posts
        let tagPool = ["#GenshinImpact", "#Cosplay", "#Anime", "#Props", "#EVA", "#JJK", "#Nier", "#WigStyling", "#Cyberpunk", "#Manga"]
        
        for i in 7...13 {
            let user = usernames[0]
            let location = locations.randomElement()!
            let caption = captions.randomElement()!
            let placeholderImage = String(format: "new_cosplay_%02d", i)
            let likes = Int.random(in: 10...5000)
            let comments = Int.random(in: 0...100)
            
            let post = WLDArticle(
                id: "\(i)",
                userId: "user_sim_\(i)",
                username: user,
                userAvatarURL: "",  // No avatar

                postImageURL: placeholderImage,  // Local placeholder
                caption: caption,
                likes: likes,
                comments: comments,
                timestamp: "\(Int.random(in: 1...23))h ago",
                videoName: nil,
                location: location,
                tags: tagPool.shuffled().prefix(2).map { $0 },
                isLiked: Bool.random()
            )
            posts.append(post)
        }
        
        return posts
    }
}
