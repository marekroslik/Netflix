import Foundation
import UIKit

final class HomeViewCoordinator: Coordinator {
   
    private(set) var childCoordinators: [Coordinator] = []

    var rootViewController = UINavigationController()
    
    lazy var homeViewController = HomeViewController()
    
    func start() {
        rootViewController.setViewControllers([homeViewController], animated: false)
    }
}
