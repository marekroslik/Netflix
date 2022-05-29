import UIKit
import SnapKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set controllers for tab bar
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: CommingSoonViewController())
        let vc3 = UINavigationController(rootViewController: FavoritesViewController())
        
        // Add tab bar settings
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.square")
        vc3.tabBarItem.image = UIImage(systemName: "heart")
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Favorites"
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .black
        setViewControllers([vc1, vc2, vc3], animated: true)
        updateValue(controller: vc3, value: 1)
        
        view.backgroundColor = .black
    }
   
    // Update badge value
    private func updateValue(controller: UINavigationController, value: Int) {
        controller.tabBarItem.badgeValue = "\(value)"
    }
}
