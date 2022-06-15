import Foundation
import UIKit

final class OnBoardingCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {        
        let onBoardingViewController = OnBoardingViewController()
        let onBoardingViewModel = OnBoardingViewModel(coordinator: self)
        onBoardingViewController.viewModel = onBoardingViewModel
        navigationController.setViewControllers([onBoardingViewController], animated: false)
    }
    
    func startLogin() {
        let loginCoordinator = LoginViewCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
}
