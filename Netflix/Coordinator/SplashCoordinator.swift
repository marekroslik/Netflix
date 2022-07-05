import Foundation
import UIKit

protocol SplashCoordinatorProtocol: Coordinator {
    func showSplashViewController()
}

class SplashCoordinator: BaseCoordinator, SplashCoordinatorProtocol {
    
    var type: CoordinatorType { .splash }
        
    required init(_ navigationController: UINavigationController) {
        super.init(navigationController)
    }
        
    func start() {
        showSplashViewController()
    }
    
    func showSplashViewController() {
        let loginVC: SplashViewController = .init()
        loginVC.viewModel = SplashViewModel(apiClient: APIClient())
        loginVC.viewModel.didSendEventClosure = { [weak self] event in
            self?.finishWith(splashEvent: event)
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
}
