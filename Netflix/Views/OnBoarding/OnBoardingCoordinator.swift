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
        navigationController.setViewControllers([onBoardingViewController], animated: false)
    }
}
