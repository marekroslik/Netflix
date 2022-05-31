import Foundation
import UIKit

class OnBoardingCoordinator: Coordinator {
    
    var rootViewController = UIViewController()
    
    func start() {
        let view = OnBoardingViewController()
        rootViewController = view
    }
}
