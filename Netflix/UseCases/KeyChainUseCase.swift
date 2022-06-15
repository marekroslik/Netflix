//
//  KeyChainUseCase.swift
//  Netflix
//
//  Created by Marek Roslik on 14.06.22.
//

import Foundation

class KeyChainUseCase {
    
    // KeyChainErrors
    enum KeyChainError: Error {
        case duplicateEntry
        case noPassword
        case unexpectedPasswordData
        case unknown(OSStatus)
    }
    
    static func saveLoginAndPassword(login: String, password: Data) throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: login,
            kSecAttrServer as String: "Netflix",
            kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeyChainError.unknown(status) }
    }
    
    static func getLoginAndPassword() throws -> (login: String, password: String) {
       
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "Netflix",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeyChainError.noPassword }
        guard status == errSecSuccess else { throw KeyChainError.unknown(status) }
        
        guard let existingItem = item as? [String: Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeyChainError.unexpectedPasswordData
        }
        return (login: account, password: password)
    }
    
    static func updateLoginAndPassword(login: String, password: String) throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "Netflix"]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: login,
            kSecValueData as String: password.data(using: String.Encoding.utf8)!]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeyChainError.noPassword }
        guard status == errSecSuccess else { throw KeyChainError.unknown(status) }
    }
    
    static func deleteLoginAndPassword() throws {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "Netflix"]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeyChainError.unknown(status) }
    }
    
}
