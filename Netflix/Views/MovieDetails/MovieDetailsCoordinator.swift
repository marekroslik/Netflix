import Foundation
import UIKit

final class MovieDetailsCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let movieDetailsViewController = MovieDetailsViewController()
        navigationController.setViewControllers([movieDetailsViewController], animated: false)
    }
}
