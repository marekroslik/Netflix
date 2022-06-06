import Foundation
import UIKit
import RxCocoa
import RxSwift

final class ApplicationCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let navigationController = UINavigationController()
        
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        
        childCoordinators.append(splashCoordinator)
        
        splashCoordinator.start()
        
        window.rootViewController =  navigationController
        window.makeKeyAndVisible()
        
    }
}
