import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    let input: Input
    let output: Output
    
    struct Input {
        let email: AnyObserver<String>
        let password: AnyObserver<String>
        let loginTrigger: AnyObserver<Void>
        let showHidePasswordTrigger: AnyObserver<Void>
        let error: AnyObserver<String>
    }
    
    struct Output {
        let inputValidating: Driver<Bool>
        let showHidePassword: Driver<Bool>
//        let accessAccept: Driver<Void>
//        let accessDenied: Driver<String>
    }
    
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    private let email = ReplaySubject<String>.create(bufferSize: 1)
    private let password = ReplaySubject<String>.create(bufferSize: 1)
    private let loginTrigger = PublishSubject<Void>()
    private let showHidePasswordTrigger = PublishSubject<Void>()
    private let error = PublishSubject<String>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        
        let inputValidating = Observable
            .combineLatest(email.startWith(""), password.startWith("")) { email, password  in
            return email.count >= 1  && password.count >= 4
        }
            .startWith(false)
            .asDriver(onErrorJustReturn: (false))
        
        let showHidePassword = showHidePasswordTrigger
            .map { () -> Bool in
                print("tap")
                return false
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: (true))
        
        self.input = Input(
            email: email.asObserver(),
            password: password.asObserver(),
            loginTrigger: loginTrigger.asObserver(),
            showHidePasswordTrigger: showHidePasswordTrigger.asObserver(),
            error: error.asObserver()
        )
        self.output = Output(inputValidating: inputValidating, showHidePassword: showHidePassword)
    }
}
