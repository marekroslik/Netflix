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
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self
        loginViewController.viewModel = loginViewModel
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}
