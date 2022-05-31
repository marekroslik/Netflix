import Foundation
import UIKit

class HomeViewCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var homeViewController = HomeViewController()
    
    func start() {
        rootViewController.setViewControllers([homeViewController], animated: false)
    }
}
