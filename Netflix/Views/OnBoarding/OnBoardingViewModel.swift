import Foundation

final class OnBoardingViewModel {
    
    var didSendEventClosure: ((OnBoardingViewController.Event) -> Void)?
    
    func signIn() {
        print("SignIn tap")
        didSendEventClosure?(.login)
    }
}
