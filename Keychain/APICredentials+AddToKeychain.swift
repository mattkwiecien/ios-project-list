//
//  APICredentials+Store.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/11/20.
//

import Foundation

extension APICredentials {
	
	func addToKeychain() -> Bool {
		let tokenData = self.token.data(using: .utf8)!
		let server = APICredentials.baseUrl.data(using: .utf8)!
		let issuer = self.conm.data(using: .utf8)!
		
		let attributes: [String: Any] = [
			String(kSecClass): kSecClassInternetPassword,
			String(kSecAttrAccount): issuer,
			String(kSecAttrServer): server,
			String(kSecValueData): tokenData
		]
		
		var result: CFTypeRef? = nil
		let status = SecItemAdd(attributes as CFDictionary, &result)
		
		if status == errSecSuccess {
			print("Successfully added to keychain.")
		} else {
			if let error: String = SecCopyErrorMessageString(status, nil) as String? {
				print(error)
			}
			
			return false
		}
		
		return true
	}
	
}
