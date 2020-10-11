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
	
	let btRestClient = RestManager("https://stage.bigtime.net/BigtimeData/api/v2")

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let existingLogin = APICredentials.getFromKeychain() {
			print("Found existing saved credentials with conm \(existingLogin.conm) and token\(existingLogin.token)")
		} else {
			print("No credentials found.")
		}
		
		password.text = ""
		email.text = ""
		
	}
	
	@IBAction func loginTouchUp(_ sender: UIButton) {
		
		btRestClient.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
		
		let email = self.email.text ?? ""
		btRestClient.httpBodyParameters.add(value: email, forKey: "UserId")
		
		let pass = self.password.text ?? ""
		btRestClient.httpBodyParameters.add(value: pass, forKey: "Pwd")
		
		
		btRestClient.makeRequest(toAction: "/session", withHttpMethod: .post) { (results) in
			if let data = results.data {
				let decoder = JSONDecoder()
				guard let sessionData = try? decoder.decode(BTSessionData.self, from: data) else { return }
				
				let myCreds = APICredentials.init(btSessionData: sessionData)
				print("Firm: \(sessionData.firm!)")
				print("Token: \(sessionData.token!)")
				
				if (myCreds.addToKeychain()){
					print("Credentials saved in keychain")
				}
				
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {

	}

}

