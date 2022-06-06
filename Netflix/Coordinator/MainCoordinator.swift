import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []
    
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        
        // Customize
        tabBarController.tabBar.tintColor = .red
        tabBarController.tabBar.backgroundColor = .black
        
        // Fix iOS 15 UITabBarController tabBar background color
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
    }
    
    func start() {
        
        // Home
        let firstCoordinator = HomeViewCoordinator()
        firstCoordinator.start()
        self.childCoordinators.append(firstCoordinator)
        let firstViewController = firstCoordinator.rootViewController
        firstViewController.tabBarItem.setup(
            title: "Home",
            imageName: "house",
            selectedImageName: "house.fill")
        
        // CommingSoon
        let secondCoordinator = ComingSoonCoordinator()
        secondCoordinator.start()
        self.childCoordinators.append(secondCoordinator)
        let secondViewController = secondCoordinator.rootViewController
        secondViewController.tabBarItem.setup(
            title: "Cooming Soon",
            imageName: "play.square",
            selectedImageName: "play.square.fill")
        
        // Favorites
        let thirdCoordinator = FavoritesCoordinator()
        thirdCoordinator.start()
        self.childCoordinators.append(thirdCoordinator)
        let thirdViewController = thirdCoordinator.rootViewController
        thirdViewController.tabBarItem.setup(
            title: "Favorites",
            imageName: "heart",
            selectedImageName: "heart.fill")
        
        tabBarController.viewControllers = [firstViewController, secondViewController, thirdViewController]
    }
}
