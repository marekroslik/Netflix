import Foundation
import RxSwift
import RxCocoa

final class UserUseCase {
    
    private let userDefaults = UserDefaults.standard
    
    var isUserLogin: Bool {
        
        get { return userDefaults.bool(forKey: "isLogin") }
        
        set { userDefaults.set(newValue, forKey: "isLogin") }
    }
    
    func tryToLoginWith(email: String, password: String) -> Single<Bool> {
        
        return Single<Bool>.create { single in
           
            // Success event
            if (email == "email") && (password == "123") {
                single(.success(true))
            } else {
                single(.success(false))
            }
            single(.failure(UserUseCaseError.userDefaults))
            return Disposables.create()
        }
        
    }
    
    enum UserUseCaseError: Error {
        case userDefaults
    }
}
