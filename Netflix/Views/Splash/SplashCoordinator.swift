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
        let splashViewModel = SplashViewModel()
        splashViewModel.coordinator = self
        splashViewController.viewModel = splashViewModel
        navigationController.setViewControllers([splashViewController], animated: false)
    }
    
    func startOnBoarding() {
        let onBoardingCoordinator = OnBoardingCoordinator(navigationController: navigationController)
        childCoordinators.append(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
}
