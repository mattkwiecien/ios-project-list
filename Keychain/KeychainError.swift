//
//  KeychainError.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/11/20.
//

import Foundation

enum KeychainError : Error {
	case noPassword
	case unexpectedPasswordData
	case unhandledError(status: OSStatus)
}
