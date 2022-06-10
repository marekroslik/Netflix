import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
   
    var coordinator: LoginViewCoordinator?
    
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(emailTextPublishSubject.asObserver()
                .startWith(""), passwordTextPublishSubject.asObserver().startWith(""))
            .map { username, password in
            return username.count > 3 && password.count > 5
        }.startWith(false)
    }
}
