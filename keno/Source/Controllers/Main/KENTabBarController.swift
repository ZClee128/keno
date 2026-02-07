import UIKit

class KENTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let feedVC = UINavigationController(rootViewController: KENFeedViewController())
        feedVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let discoveryVC = UINavigationController(rootViewController: KENDiscoveryViewController())
        discoveryVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let postVC = UIViewController() // Dummy VC
        postVC.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "plus.circle.fill"), tag: 2)

        let chatVC = UINavigationController(rootViewController: KENChatListViewController())
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message.fill"), tag: 3)
        
        // Profile
        let profileVC = UINavigationController(rootViewController: KENProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 4)
        
        viewControllers = [feedVC, discoveryVC, postVC, chatVC, profileVC]
        delegate = self
    }
    
    private func setupAppearance() {
        tabBar.tintColor = KENConstants.Colors.reptileGreen
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .white
    }
}

extension KENTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return true }
        
        // Protected Tabs: Post (2), Chat (3), Profile (4)
        if [2, 3, 4].contains(index) {
            if !KENAuthManager.shared.isLoggedIn {
                KENAuthManager.shared.ensureLoggedIn(on: self) {
                    if index == 2 {
                        self.presentPostModal()
                    } else {
                        self.selectedIndex = index
                    }
                }
                return false
            }
        }
        
        // Modal for Post button specifically (if logged in)
        if index == 2 {
            presentPostModal()
            return false
        }
        
        return true
    }
    
    private func presentPostModal() {
        let createPostVC = UINavigationController(rootViewController: KENCreatePostViewController())
        createPostVC.modalPresentationStyle = .fullScreen
        present(createPostVC, animated: true)
    }
}
