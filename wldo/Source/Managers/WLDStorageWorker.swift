import Foundation
import UIKit

class WLDStorageWorker {
    static let shared = WLDStorageWorker()
    
    private init() {}
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func save<T: Codable>(_ object: T, to fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
        } catch {
            print("Error saving object to \(fileName): \(error)")
        }
    }
    
    func load<T: Codable>(from fileName: String) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error loading object from \(fileName): \(error)")
            return nil
        }
    }
    func saveImage(_ image: UIImage, fileName: String) -> String? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        do {
            try data.write(to: url)
            return fileName // Return just the filename for persistence
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    func deleteFile(name: String) {
        let url = getDocumentsDirectory().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error deleting file \(name): \(error)")
            }
        }
    }
}
