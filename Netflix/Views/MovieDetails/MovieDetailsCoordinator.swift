import Foundation
import UIKit

final class MovieDetailsCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []

    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let movieDetailsViewController = MovieDetailsViewController()
        navigationController.setViewControllers([movieDetailsViewController], animated: false)
    }
}
