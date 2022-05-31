import Foundation
import UIKit

class FavoritesCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var favortitesViewController = FavoritesViewController()
    
    func start() {
        rootViewController.setViewControllers([favortitesViewController], animated: false)
    }
}
