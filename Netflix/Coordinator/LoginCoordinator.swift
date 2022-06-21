import Foundation
import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func showOnBoardingViewController()
    func showLoginViewController()
}

class LoginCoordinator: BaseCoordinator, LoginCoordinatorProtocol {
    
    var type: CoordinatorType { .login }
        
    required init(_ navigationController: UINavigationController) {
        super.init(navigationController)
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
        loginVC.viewModel.didSendEventClosure = { [weak self] event in
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
        loginVC.viewModel.didSendEventClosure = { [weak self] event in
            switch event {
            case .main:
                self?.finish()
            }
        }
        navigationController.setViewControllers([loginVC], animated: false)
    }
}
