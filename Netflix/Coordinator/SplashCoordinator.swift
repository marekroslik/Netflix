import Foundation
import UIKit

protocol SplashCoordinatorProtocol: Coordinator {
    func showSplashViewController()
}

class SplashCoordinator: SplashCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .splash }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showSplashViewController()
    }
    
    deinit {
        print("SplashCoordinator deinit")
    }
    
    func showSplashViewController() {
        let loginVC: SplashViewController = .init()
        loginVC.viewModel = SplashViewModel()
        loginVC.viewModel.didSendEventClosure = { [weak self] event in
            self?.finishWith(splashEvent: event)
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
}
