//
//  SecureManager.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 20.11.2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation
import LocalAuthentication

enum KeychainError: Error {
    case noPassword(description: String)
    case unexpectedPasswordData(description: String)
    case unhandledError(status: OSStatus)
}

enum LocalAuthError: Error {
    case policyError(description: String)
}

struct SecureManager {
    private let server = "https://github.com"
    
    func saveToKeychain(login: String, password: Data) -> Bool {
        let query = setupQuery(login: login, password: password)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            // TODO: catch an error
            return false
        }
        
        return true
    }
    
    func getFromKeychain(completionHandler: @escaping ((Bool, String, String, String)) -> Void) throws {
        let query = setupQuery(login: nil, password: nil)
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword(description: "Ошибка поиска данных в keychain") }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData(description: "Ошибка формата данных keychain")
        }
        
        let context = LAContext()
        var error: NSError?
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            throw LocalAuthError.policyError(description: error!.localizedDescription)
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to your github account") { (success, error) in
            DispatchQueue.main.async {
                if success {
                    completionHandler((true, "", account, password))
                } else {
                    completionHandler((false, error?.localizedDescription ?? "Failed to authenticate", "", ""))
                }
            }
        }
    }
    
    
    private func setupQuery(login: String?, password: Data?) -> [String : Any] {
        var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        
        if login != nil, password != nil {
            query[kSecAttrAccount as String] = login
            query[kSecValueData as String] = password
        } else {
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = true
            query[kSecReturnData as String] = true
        }
        
        return query
    }
    
}
