import Foundation
import UIKit

final class SplashCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashViewController = SplashViewController()
        let splashViewModel = SplashViewModel()
        splashViewModel.coordinator = self
        splashViewController.viewModel = splashViewModel
        navigationController.setViewControllers([splashViewController], animated: false)
    }
    
    func startOnBoarding() {
        let onBoardingCoordinator = LoginViewCoordinator(navigationController: navigationController)
        childCoordinators.append(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    func startDashboard() {
        let dashboardCoordinator = LoginViewCoordinator(navigationController: navigationController)
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
}
