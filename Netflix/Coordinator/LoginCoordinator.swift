import Foundation
import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showOnBoardingViewController()
    func showLoginViewController()
}

class LoginCoordinator: LoginCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .login }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
        
    func start() {
        showOnBoardingViewController()
    }
    
    deinit {
        print("LoginCoordinator deinit")
    }
    
    func showOnBoardingViewController() {
        let loginVC: OnBoardingViewController = .init()
        loginVC.viewModel = OnBoardingViewModel()
        loginVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .login:
                self?.showLoginViewController()
            }
        }
        navigationController.pushViewController(loginVC, animated: true)
    }
    func showLoginViewController() {
        let loginVC: LoginViewController = .init()
        loginVC.viewModel = LoginViewModel()
        loginVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .main:
                self?.finish()
            }
        }
        navigationController.setViewControllers([loginVC], animated: false)
    }
}
