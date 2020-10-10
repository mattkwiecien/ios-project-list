//
//  ViewController.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/9/20.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet fileprivate var password: UITextField!
	@IBOutlet fileprivate var email: UITextField!
	
	@IBOutlet weak var loginButton: UIButton!
	
	let rest = RestManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		password.text = ""
		email.text = ""
		
	}
	
	@IBAction func loginTouchUp(_ sender: UIButton) {
		print("Login pressed.")
		guard let url = URL(string: "https://stage.bigtime.net/BigtimeData/api/v2/session") else { return }
		
		rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
		if let email = self.email.text {
			rest.httpBodyParameters.add(value: email, forKey: "UserId")
		}
		if let pass = self.password.text {
			rest.httpBodyParameters.add(value: pass, forKey: "Pwd")
		}
		
		rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
			if let data = results.data {
//				print(data)
				let decoder = JSONDecoder()
				guard let sessionData = try? decoder.decode(BTSession.self, from: data) else { return }
				print("Firm: \(sessionData.firm!)")
				print("Token: \(sessionData.token!)")
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {

	}

}

