import Foundation
import UIKit

final class OnBoardingCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onBoardingViewController = OnBoardingViewController()
        navigationController.setViewControllers([onBoardingViewController], animated: false)
    }
}
