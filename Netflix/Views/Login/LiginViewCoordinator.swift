import Foundation
import UIKit

class LiginViewCoordinator: Coordinator {
    
    var rootViewController = UIViewController()
    
    func start() {
        let view = LoginViewController()
        rootViewController = view
    }
}
