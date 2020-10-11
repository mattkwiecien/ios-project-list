//
//  APICredentials+BTSessionData.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/11/20.
//

import Foundation

extension APICredentials {
	
	init(btSessionData data: BTSessionData) {
		self.conm = data.firm ?? ""
		self.token = data.token ?? ""
	}
	
}
