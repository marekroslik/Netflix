import Foundation
import UIKit

final class ComingSoonCoordinator: Coordinator {

    private(set) var childCoordinators: [Coordinator] = []

    var rootViewController = UINavigationController()
    
    lazy var cominSoonViewController = ComingSoonViewController()
    
    func start() {
        rootViewController.setViewControllers([cominSoonViewController], animated: false)
    }
}
