import Foundation
import UIKit

final class LoginViewCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}
