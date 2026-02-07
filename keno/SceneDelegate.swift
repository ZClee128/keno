import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Guest Mode: Always start with Tab Bar
        switchToMainApp()
        
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
    }
    
    func switchToMainApp() {
        let tabBar = KENTabBarController()
        window?.rootViewController = tabBar
        
        // Animated transition
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    func switchToLogin() {
        let loginVC = KENLoginViewController()
        window?.rootViewController = loginVC
        
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
