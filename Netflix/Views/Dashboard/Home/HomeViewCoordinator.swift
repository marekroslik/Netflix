import Foundation
import UIKit

final class HomeViewCoordinator: Coordinator {
   
    private var childCoordinators: [Coordinator] = []
    
    // I will set private. When will do dashboard. Need to make some changes.
    let rootViewController = UINavigationController()
    
    let homeViewController = HomeViewController()
    
    func start() {
        rootViewController.setViewControllers([homeViewController], animated: false)
    }
}
