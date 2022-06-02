import Foundation
import UIKit

final class ApplicationCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        
//        let tabBarController = UITabBarController()
        
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        
        childCoordinators.append(splashCoordinator)
        
        splashCoordinator.start()
        
        window.rootViewController =  navigationController
        window.makeKeyAndVisible()
        
    }
}
