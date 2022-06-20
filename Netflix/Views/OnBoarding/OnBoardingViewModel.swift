import Foundation

final class OnBoardingViewModel {
    
    func signIn(didSendEventClosure: ((OnBoardingViewController.Event) -> Void)?) {
        print("SignIn tap")
        didSendEventClosure?(.login)
    }
}
