//
//  RestManager.swift
//  ProjectList
//
//  Created by Matt Kwiecien on 10/10/20.
//

import Foundation

class RestManager {
	
	let baseUrl: String
	var requestHttpHeaders = RestEntity()
	var urlQueryParameters = RestEntity()
	var httpBodyParameters = RestEntity()
	var httpBody: Data?
	
	
	init(_ url: String) {
		baseUrl = url
	}
	
	func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async {
			let sessionConfiguration = URLSessionConfiguration.default
			let session = URLSession(configuration: sessionConfiguration)
			let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
				guard let data = data else { completion(nil); return }
				completion(data)
			})
			task.resume()
		}
	}
	
	func makeRequest(toAction action: String, withHttpMethod httpMethod: HttpMethod, completion: @escaping (_ result: Results) -> Void) {
		
		guard let url = URL(string: baseUrl + action) else { return }
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			let targetURL = self?.addURLQueryParameters(toURL: url)
			let httpBody = self?.getHttpBody()
			guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else
			{
				completion(Results(withError: CustomError.failedToCreateRequest))
				return
			}
			
			let sessionConfiguration = URLSessionConfiguration.default
			let session = URLSession(configuration: sessionConfiguration)
			let task = session.dataTask(with: request) { (data, response, error) in
				completion(Results(withData: data,
								   response: Response(fromURLResponse: response),
								   error: error))
			}
			task.resume()
		}

	}
	
	private func addURLQueryParameters(toURL url: URL) -> URL {
		if urlQueryParameters.totalItems() > 0 {
			guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
			var queryItems = [URLQueryItem]()
			for (key, value) in urlQueryParameters.allValues() {
				let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
				
				queryItems.append(item)
			}
			urlComponents.queryItems = queryItems
			guard let updatedURL = urlComponents.url else { return url }
			return updatedURL
		}
		
		return url
	}
	
	private func getHttpBody() -> Data? {
		guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
		
		if contentType.contains("application/json") {
			return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
		} else if contentType.contains("application/x-www-form-urlencoded") {
			let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
			return bodyString.data(using: .utf8)
		} else {
			return httpBody
		}
	}
	
	private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
		guard let url = url else { return nil }
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		
		for (header, value) in requestHttpHeaders.allValues() {
			request.setValue(value, forHTTPHeaderField: header)
		}
		
		request.httpBody = httpBody
		return request
	}
	
}

extension RestManager.CustomError: LocalizedError {
	public var localizedDescription: String {
		switch self {
		case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
		}
	}
}
