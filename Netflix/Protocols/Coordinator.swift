import Foundation

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    func start()
}
