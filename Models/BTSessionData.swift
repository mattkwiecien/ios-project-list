//
//  Session.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/10/20.
//

import Foundation

class BTSessionData : Decodable {
	var firm: String?
	var staffsid: Int64?
	var userid: Int64?
	var token: String?
}
