import UIKit

struct WLDAppConfig {
    struct Colors {
        static let lifestyleAccent = UIColor(red: 0.61, green: 0.53, blue: 0.45, alpha: 1.00) // Aesthetic Warm Taupe/Brown
        static let accentGreen = UIColor(red: 0.72, green: 0.65, blue: 0.58, alpha: 1.00) // Lighter Taupe
        static let darkScale = UIColor(red: 0.15, green: 0.13, blue: 0.12, alpha: 1.00) // Dark Brown/Charcoal
        
        static let background = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.00) // Soft Gray-Blue
        static let cardBackground = UIColor.white
        
        static let textPrimary = UIColor(red: 0.10, green: 0.10, blue: 0.12, alpha: 1.00)
        static let textSecondary = UIColor(red: 0.50, green: 0.50, blue: 0.55, alpha: 1.00)
        
        static let sand = UIColor(red: 0.96, green: 0.96, blue: 0.93, alpha: 1.00) // Keep for legacy if needed
        static let shadow = UIColor.black.withAlphaComponent(0.1)
    }
    
    struct Fonts {
        static func header(size: CGFloat = 24) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        
        static func title(size: CGFloat = 18) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        static func body(size: CGFloat = 16) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func caption(size: CGFloat = 14) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        // Legacy support
        static func heavy(size: CGFloat) -> UIFont { return UIFont.systemFont(ofSize: size, weight: .heavy) }
        static func medium(size: CGFloat) -> UIFont { return UIFont.systemFont(ofSize: size, weight: .medium) }
        static func regular(size: CGFloat) -> UIFont { return UIFont.systemFont(ofSize: size, weight: .regular) }
    }
}

// MARK: - Obfuscation Junk Code
struct WLDJunk {
    static func initialize() {
        let _ = WLDHelper.randomString(length: 10)
        let _ = WLDProcessor.compute(value: 42)
        print("WLDJunk initialized")
    }
}

class WLDHelper {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

class WLDProcessor {
    static func compute(value: Int) -> Int {
        var result = value
        for i in 0..<10 {
            result += i * 2
        }
        return result
    }
    
    func complicatedOperation() {
        let views = [UIView(), UILabel(), UIButton()]
        for view in views {
            view.alpha = 0.5
            view.backgroundColor = .red
        }
    }
}
