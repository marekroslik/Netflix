import UIKit

// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator {
    func showSplashFlow()
    func showLoginFlow()
    func showMainFlow()
}

// App coordinator is the only one coordinator which will exist during app's life cycle
class AppCoordinator: AppCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .app }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showSplashFlow()
    }
        
    func showSplashFlow() {
        let splashCoordinator = SplashCoordinator.init(navigationController)
        splashCoordinator.finishDelegate = self
        splashCoordinator.start()
        childCoordinators.append(splashCoordinator)
    }
    
    func showLoginFlow() {
        // Implement Login FLow
        let loginCoordinator = LoginCoordinator.init(navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showMainFlow() {
        // Implement Main (Tab bar) FLow
        let tabCoordinator = MainCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })

        switch childCoordinator.type {
        case .splash:
            navigationController.viewControllers.removeAll()
            showLoginFlow()
            
        case .login:
            navigationController.viewControllers.removeAll()
            showMainFlow()
            
        case .main:
            navigationController.viewControllers.removeAll()
            showLoginFlow()
            
        default:
            break
        }
    }
    
    func coordinatorDidFinish(childCoordinator: Coordinator, splashEvent: SplashViewController.Event) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        case .splash:
            navigationController.viewControllers.removeAll()
            switch splashEvent {
            case .login:
                showLoginFlow()
            case .main:
                showMainFlow()
            }
        default:
            break
        }
    }
}
