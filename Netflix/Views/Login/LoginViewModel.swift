import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    var coordinator: LoginViewCoordinator?
    
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    private var token: TokenResponseModel?
    private var loginPost: LoginPostResponseModel?
    private var login: LoginResponseModel?
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(emailTextPublishSubject.asObserver()
                .startWith(""), passwordTextPublishSubject.asObserver().startWith(""))
            .map { username, password in
                return username.count > 3 && password.count > 5
            }.startWith(false)
    }
    
    func getToken(bag: DisposeBag) {
        let client = APIClient.shared
        client.getToken().subscribe(
            onNext: { [weak self] result in
                self?.token = result
                print("Token - \(result)")
            },
            onError: { error in
                print(error.localizedDescription)
            }).disposed(by: bag)
    }
    
    func authenticationWithLoginPassword(login: String, password: String, bag: DisposeBag) {
        let client = APIClient.shared
        self.loginPost = LoginPostResponseModel(username: login, password: password, requestToken: self.token!.requestToken)
        client.authenticationWithLoginPassword(loginModel: loginPost! ).subscribe(
            onNext: { [weak self] result in
                self?.login = result
                print("Login - \(result)")
            },
            onError: { error in
                switch error {
                case APIError.wrongPassword:
                    print(APIError.wrongPassword)
                    
                default: print(error.localizedDescription)
                }
            }).disposed(by: bag)
    }
}
