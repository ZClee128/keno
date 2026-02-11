import UIKit

class WLDBitmapFetcher {
    static let shared = WLDBitmapFetcher()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check cache first
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // Check if it's a local asset name (no scheme like http://)
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            let fileName = urlString.components(separatedBy: "/").last ?? urlString
            
            // Try Assets.xcassets first (most common for local resources)
            if let image = UIImage(named: fileName) {
                self.cache.setObject(image, forKey: urlString as NSString)
                completion(image)
                return
            }
            
            // Try Documents directory second
            let docPath = WLDStorageWorker.shared.getDocumentsDirectory().appendingPathComponent(fileName).path
            if let image = UIImage(contentsOfFile: docPath) {
                self.cache.setObject(image, forKey: urlString as NSString)
                completion(image)
                return
            }
            
            // If still not found, return placeholder
            completion(UIImage(systemName: "photo"))
            return
        }
        
        // Handle remote URLs
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "photo"))
                }
                return
            }
            
            self.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
