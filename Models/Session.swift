//
//  Session.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/10/20.
//

import Foundation

class BTSession : Decodable {
//	{firm: 'abc3-4567-fgr4', staffsid: 21, userid: 999, token: 'asdf-werq-3asdf-ase5-qfaw5e' ... }
	var firm: String!
	var staffsid: Int64!
	var userid: Int64!
	var token: String!
}
