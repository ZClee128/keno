import UIKit

struct WLDAppConfig {
    struct Colors {
        static let lifestyleAccent = UIColor.label // Primary tint is just black/white adaptive
        static let accentGreen = UIColor.systemGray2 // Lighter touch
        static let darkScale = UIColor.systemBackground // For backgrounds
        
        static let background = UIColor.systemGroupedBackground // Default gray-ish or black in dark mode
        static let cardBackground = UIColor.secondarySystemGroupedBackground
        
        static let textPrimary = UIColor.label
        static let textSecondary = UIColor.secondaryLabel
        
        static let sand = UIColor.systemGray6 // Legacy support alias
        static let shadow = UIColor.black.withAlphaComponent(0.05)
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


