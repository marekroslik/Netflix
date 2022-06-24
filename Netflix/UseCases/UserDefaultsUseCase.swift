import Foundation
import RxSwift
import RxCocoa

final class UserDefaultsUseCase {

    private let userDefaults = UserDefaults.standard

    var token: String? {

        get { return userDefaults.string(forKey: "token") }

        set { userDefaults.set(newValue, forKey: "token") }
    }
    
    var sessionId: String? {

        get { return userDefaults.string(forKey: "sessionId") }

        set { userDefaults.set(newValue, forKey: "sessionId") }
    }
    
    func resetDefaults() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
