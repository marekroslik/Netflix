import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        // Splash
//        let splashCoordinator = SplashCoordinator()
//        splashCoordinator.start()
//        self.childCoordinators = [splashCoordinator]
//        window.rootViewController = splashCoordinator.rootViewController
        
        // OnBoarding
//        let onBoardingCoordinator = OnBoardingCoordinator()
//        onBoardingCoordinator.start()
//        self.childCoordinators = [onBoardingCoordinator]
//        window.rootViewController = onBoardingCoordinator.rootViewController
        
        // Login
//        let loginCoordinator = LiginViewCoordinator()
//        loginCoordinator.start()
//        self.childCoordinators = [loginCoordinator]
//        window.rootViewController = loginCoordinator.rootViewController
        
//        // MovieDetails
//        let movieDetailsCoordinator = MoviewDetailsCoordinator()
//        movieDetailsCoordinator.start()
//        self.childCoordinators = [movieDetailsCoordinator]
//        window.rootViewController = movieDetailsCoordinator.rootViewController
       
//         Dashboard
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.rootViewController
        
    }
}
