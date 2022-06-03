import Foundation

final class SplashViewModel {
    
    var coordinator: SplashCoordinator?
    func timer() {
        print("timer start")
        sleep(2)
        print("timer end")
        coordinator?.startOnBoarding()
    }
}
