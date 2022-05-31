import Foundation
import UIKit

class CommingSoonCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    
    lazy var comminSoonViewController = CommingSoonViewController()
    
    func start() {
        rootViewController.setViewControllers([comminSoonViewController], animated: false)
    }
}
