import UIKit

class WLDMainTab: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let feedVC = UINavigationController(rootViewController: WLDFeedViewController())
        feedVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let discoveryVC = UINavigationController(rootViewController: WLDDiscoveryViewController())
        discoveryVC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "calendar"), tag: 1)
        
        // Profile
        let profileVC = UINavigationController(rootViewController: WLDProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
        viewControllers = [feedVC, discoveryVC, profileVC]
        delegate = self
    }
    
    private func setupAppearance() {
    }
}

extension WLDMainTab: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
