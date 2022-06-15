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
        let splashViewModel = SplashViewModel(coordinator: self)
        splashViewController.viewModel = splashViewModel
        navigationController.setViewControllers([splashViewController], animated: false)
    }
    
    func startOnBoarding() {
        let onBoardingCoordinator = OnBoardingCoordinator(navigationController: navigationController)
        childCoordinators.append(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
    
    func startDashboard() {
        // Need it ERROR - Cannot convert value of type 'UINavigationController' to expected argument type 'UITabBarController'
//        let dashboardCoordinator = MainCoordinator(tabBarController: navigationController)
        
        let dashboardCoordinator = LoginViewCoordinator(navigationController: navigationController)
        childCoordinators.append(dashboardCoordinator)
        dashboardCoordinator.start()
    }
}
