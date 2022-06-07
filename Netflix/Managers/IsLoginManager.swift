import Foundation

final class IsLoginManager {
    
    let userDefaults = UserDefaults.standard
    
    // Check user status
    func check() -> Bool {
        return userDefaults.bool(forKey: "isLogin")
    }
    
    // Set user status
    func set(value: Bool) {
        userDefaults.set(value, forKey: "isLogin")
    }
}
