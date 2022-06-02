import Foundation
import UIKit

final class SplashCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashViewController = SplashViewController()
        navigationController.setViewControllers([splashViewController], animated: false)
    }
}
