import Foundation
import UIKit

final class LoginViewCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}
