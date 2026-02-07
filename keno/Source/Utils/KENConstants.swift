import UIKit

struct KENConstants {
    struct Colors {
        static let reptileGreen = UIColor(red: 0.13, green: 0.55, blue: 0.13, alpha: 1.00) // #218C21
        static let accentGreen = UIColor(red: 0.20, green: 0.70, blue: 0.30, alpha: 1.00) // Lighter Green
        static let darkScale = UIColor(red: 0.11, green: 0.11, blue: 0.13, alpha: 1.00) // #1C1C21
        
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
