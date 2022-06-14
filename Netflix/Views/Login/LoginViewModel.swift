import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    private var coordinator: LoginViewCoordinator
    
    init (coordinator: LoginViewCoordinator) {
        self.coordinator = coordinator
    }
    
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    var errorHandling = PublishSubject<String>()
    
    private var token: TokenResponseModel?
    private var login: LoginResponseModel?
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(emailTextPublishSubject.asObserver()
                .startWith(""), passwordTextPublishSubject.asObserver().startWith(""))
            .map { username, password in
                return username.count >= 1 && password.count >= 4
            }.startWith(false)
    }
    
    func getToken(bag: DisposeBag) {
        APIClient.shared.getToken().subscribe(
            onNext: { [weak self] result in
                self?.token = result
            },
            onError: { error in
                print(error.localizedDescription)
            }).disposed(by: bag)
    }
    
    func authenticationWithLoginPassword(login: String, password: String, bag: DisposeBag) {
        let loginPost = LoginPostResponseModel(username: login, password: password, requestToken: self.token!.requestToken)
        APIClient.shared.authenticationWithLoginPassword(loginModel: loginPost ).subscribe(
            onNext: { [weak self] result in
                self?.login = result
                print("LOGIN -> SHOW DASHBOARD")
            },
            onError: { [weak self] error in
                switch error {
                case APIError.wrongPassword:
                    self?.errorHandling.onNext("Invalid username or password")
                default:
                    self?.errorHandling.onNext("Login failed. Please try again later")
                }
            }).disposed(by: bag)
    }
}
