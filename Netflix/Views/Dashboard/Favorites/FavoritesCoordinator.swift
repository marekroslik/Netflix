import Foundation
import UIKit

final class FavoritesCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    var rootViewController = UINavigationController()
    
    lazy var favortitesViewController = FavoritesViewController()
    
    func start() {
        rootViewController.setViewControllers([favortitesViewController], animated: false)
    }
}
