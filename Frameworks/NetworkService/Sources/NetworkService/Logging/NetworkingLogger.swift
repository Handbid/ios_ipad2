// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

class NetworkingLogger {
	var logLevel = NetworkingLogLevel.off

	func log(request: URLRequest) {
		guard logLevel != .off else {
			return
		}
		if let method = request.httpMethod,
		   let url = request.url
		{
			print("\(method) '\(url.absoluteString)'")
			logHeaders(request)
			logBody(request)
		}
		if logLevel == .debug {
			logCurl(request)
		}
	}

	func log(response: URLResponse, data _: Data) {
		guard logLevel != .off else {
			return
		}
		if let response = response as? HTTPURLResponse {
			logStatusCodeAndURL(response)
		}
		if logLevel == .debug {
			// print(String(decoding: data, as: UTF8.self))
		}
	}

	private func logHeaders(_ urlRequest: URLRequest) {
		if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
			for (key, value) in allHTTPHeaderFields {
				print("  \(key) : \(value)")
			}
		}
	}

	private func logBody(_ urlRequest: URLRequest) {
		if let body = urlRequest.httpBody,
		   let str = String(data: body, encoding: .utf8)
		{
			print("  HttpBody : \(str)")
		}
	}

	private func logStatusCodeAndURL(_ urlResponse: HTTPURLResponse) {
		if let url = urlResponse.url {
			print("\(urlResponse.statusCode) '\(url.absoluteString)'")
		}
	}

	private func logCurl(_ urlRequest: URLRequest) {
		print(urlRequest.toCurlCommand())
	}
}

public extension URLRequest {
	func toCurlCommand() -> String {
		guard let url else { return "" }
		var command = ["curl \"\(url.absoluteString)\""]

		if let method = httpMethod, method != "GET", method != "HEAD" {
			command.append("-X \(method)")
		}

		allHTTPHeaderFields?
			.filter { $0.key != "Cookie" }
			.forEach { command.append("-H '\($0.key): \($0.value)'") }

		if let data = httpBody, let body = String(data: data, encoding: .utf8) {
			command.append("-d '\(body)'")
		}

		return command.joined(separator: " \\\n\t")
	}
}
