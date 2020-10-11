//
//  APICredentials+Get.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/11/20.
//

import Foundation

extension APICredentials {
	
	static func getFromKeychain() -> APICredentials? {
		
		let server = APICredentials.baseUrl.data(using: .utf8)!
		let attributes: [String: Any] = [
			String(kSecClass): kSecClassInternetPassword,
			String(kSecAttrServer): server,
			String(kSecMatchLimit): kSecMatchLimitOne,
			String(kSecReturnAttributes): true,
			String(kSecReturnData): true
		]
		
		var item: CFTypeRef?
		let status = SecItemCopyMatching(attributes as CFDictionary, &item)
		
		if status == errSecSuccess {
			print("Successfully retrieved credentials.")
		} else {
			if let error: String = SecCopyErrorMessageString(status, nil) as String? {
				print(error)
			}
			
			return nil
		}
		
		guard let storedCreds = item as? [String: Any],
			  let tokenData = storedCreds[String(kSecValueData)] as? Data,
			  let token = String(data: tokenData, encoding: .utf8),
			  let conmData = storedCreds[String(kSecAttrAccount)] as? Data,
			  let conm = String(data: conmData, encoding: .utf8)
		else {
			return nil
		}
		
		let myCreds = APICredentials(conm: conm, token: token)
		return myCreds
		
	}
	
}
