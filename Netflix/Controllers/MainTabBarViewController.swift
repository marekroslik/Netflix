import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: CommingSoonViewController())
        let vc3 = UINavigationController(rootViewController: FavoritesViewController())
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
    }
}
