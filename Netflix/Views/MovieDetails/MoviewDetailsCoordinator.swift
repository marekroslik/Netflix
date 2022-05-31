import Foundation
import UIKit

class MoviewDetailsCoordinator: Coordinator {
    
    var rootViewController = UIViewController()
    
    func start() {
        let view = MoviewDetailsViewController()
        rootViewController = view
    }
}
