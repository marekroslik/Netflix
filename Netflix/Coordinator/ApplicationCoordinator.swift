import Foundation
import UIKit
import RxCocoa
import RxSwift

final class ApplicationCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let tab = UITabBarController()
        
        let splashCoordinator = MainCoordinator(tabBarController: tab)
        
//        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        
        childCoordinators.append(splashCoordinator)
        
        splashCoordinator.start()
        
        window.rootViewController =  tab
        window.makeKeyAndVisible()
        
    }
}
