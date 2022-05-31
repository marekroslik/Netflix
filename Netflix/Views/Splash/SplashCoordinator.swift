import Foundation
import UIKit

class SplashCoordinator: Coordinator {
    
    var rootViewController = UIViewController()
    
    func start() {
        let view = SplashViewController()
        rootViewController = view
    }
}
