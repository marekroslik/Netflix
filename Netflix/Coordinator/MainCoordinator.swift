import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController: UITabBarController
    
    var childCoordinator = [Coordinator]()
    
    init() {
        self.rootViewController = UITabBarController()
        
        // Customize
        rootViewController.tabBar.tintColor = .red
        rootViewController.tabBar.backgroundColor = .black
        
        // Fix iOS 15 UITabBarController tabBar background color
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            rootViewController.tabBar.standardAppearance = appearance
            rootViewController.tabBar.scrollEdgeAppearance = rootViewController.tabBar.standardAppearance
        }
    }
    
    func start() {
        
        // Home
        let firstCoordinator = HomeViewCoordinator()
        firstCoordinator.start()
        self.childCoordinator.append(firstCoordinator)
        let firstViewController = firstCoordinator.rootViewController
        setup(viewController: firstViewController,
              title: "Home",
              imageName: "house",
              selectedImageName: "house.fill")
        
        // CommingSoon
        let secondCoordinator = CommingSoonCoordinator()
        secondCoordinator.start()
        self.childCoordinator.append(secondCoordinator)
        let secondViewController = secondCoordinator.rootViewController
        setup(viewController: secondViewController,
              title: "Cooming Soon",
              imageName: "play.square",
              selectedImageName: "play.square.fill")
        
        // Favorites
        let thirdCoordinator = FavoritesCoordinator()
        thirdCoordinator.start()
        self.childCoordinator.append(thirdCoordinator)
        let thirdViewController = thirdCoordinator.rootViewController
        setup(viewController: thirdViewController,
              title: "Favorites",
              imageName: "heart",
              selectedImageName: "heart.fill")
        
        rootViewController.viewControllers = [firstViewController, secondViewController, thirdViewController]
    }
    
    // SetupViewController
    func setup(viewController: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        viewController.tabBarItem = tabBarItem
    }
    
}
