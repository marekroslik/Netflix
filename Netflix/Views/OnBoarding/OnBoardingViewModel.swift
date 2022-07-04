import Foundation
import RxSwift
import RxCocoa

final class OnBoardingViewModel: ViewModelType {
    struct Input {
        let singInTrigger: Observable<Void>
        let signUpTrigger: Observable<Void>
    }
    
    struct Output {
        let singIn: Driver<Void>
        let signUp: Driver<Void>
    }
    
    var didSendEventClosure: ((OnBoardingViewController.Event) -> Void)?
    
    func transform(input: Input) -> Output {
        
        let singIn = input.singInTrigger.map({ [weak self] _ in
            guard let self = self else { return }
            self.signIn()
        }).asDriver(onErrorJustReturn: ())
        
        let signUp = input.signUpTrigger.map({ [weak self] _ in
            guard let self = self else { return }
            self.signUp()
        }).asDriver(onErrorJustReturn: ())
        
        return Output(singIn: singIn, signUp: signUp)
    }
    
    func signIn() {
        didSendEventClosure?(.login)
    }
    
    func signUp() {
        if let url = URL(string: "https://www.themoviedb.org/signup?") {
            UIApplication.shared.open(url)
        }
    }
}
