//
//  SecureManager.swift
//  GitHubExplorer
//
//  Created by Кирилл Юдин on 20.11.2019.
//  Copyright © 2019 Кирилл Юдин. All rights reserved.
//

import Foundation

struct SecureManager {
    private let server = "https://github.com"
    
    func saveToKeychain(login: String, password: String) -> Bool {
        let query = setupQuery(login: login, password: password)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            // TODO: catch an error
            return false
        }
        
        return true
    }
    
    func getFromKeychain() {
        let query = setupQuery(login: nil, password: nil)
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
//        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
//        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    
    private func setupQuery(login: String?, password: String?) -> [String : Any] {
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
