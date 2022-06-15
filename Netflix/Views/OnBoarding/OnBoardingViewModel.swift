import Foundation

final class OnBoardingViewModel {
    private var coordinator: OnBoardingCoordinator
    
    init (coordinator: OnBoardingCoordinator) {
        self.coordinator = coordinator
    }
    
    func signIn() {
        self.coordinator.startLogin()
    }
}
