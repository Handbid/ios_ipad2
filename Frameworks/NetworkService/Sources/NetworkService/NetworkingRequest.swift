// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import KeychainAccess

public typealias NetworkRequestRetrier = (_ request: URLRequest, _ error: Error) -> AnyPublisher<Void, Error>?

extension NetworkingRequest {
	func retrieveTokenValueFromKeychain() -> String? {
		let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")
		do {
			guard let tokenData = try keychain.getData("AuthDataUser") else {
				return nil
			}

			let json = try JSONSerialization.jsonObject(with: tokenData, options: []) as? [String: Any]
			guard let value = json?["value"] as? String else {
				return nil
			}
			return value
		}
		catch {
			return nil
		}
	}
}

public class NetworkingRequest: NSObject, URLSessionTaskDelegate {
	var parameterEncoding = ParameterEncoding.urlEncoded
	var baseURL = ""
	var route = ""
	var httpMethod = HTTPMethod.get
	public var params = Params()
	public var encodableBody: Encodable?
	var headers = [String: String]()
	var multipartData: [MultipartData]?
	var logLevel: NetworkingLogLevel {
		get { logger.logLevel }
		set { logger.logLevel = newValue }
	}

	private let logger = NetworkingLogger()
	var timeout: TimeInterval?
	let progressPublisher = PassthroughSubject<Progress, Error>()
	var requestRetrier: NetworkRequestRetrier?
	private let maxRetryCount = 3
	var sessionConfiguration: URLSessionConfiguration

	override init() {
		let config = URLSessionConfiguration.default
		config.httpCookieStorage = HTTPCookieStorage.shared
		config.timeoutIntervalForResource = 30
		config.timeoutIntervalForRequest = 30
		config.tlsMinimumSupportedProtocolVersion = .TLSv12
		config.tlsMaximumSupportedProtocolVersion = .TLSv13
		config.httpShouldSetCookies = true
		config.httpCookieAcceptPolicy = .always
		config.httpAdditionalHeaders = ["Strict-Transport-Security": "max-age=31536000"]
		self.sessionConfiguration = config
	}

	public func uploadPublisher() -> AnyPublisher<(Data?, Progress), Error> {
		guard let urlRequest = buildURLRequest() else {
			return Fail(error: NetworkingError.unableToParseRequest as Error)
				.eraseToAnyPublisher()
		}
		logger.logLevel = .debug
		logger.log(request: urlRequest)

		let config = sessionConfiguration
		let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
		let callPublisher: AnyPublisher<(Data?, Progress), Error> = urlSession.dataTaskPublisher(for: urlRequest)
			.tryMap { (data: Data, response: URLResponse) -> Data in
				self.logger.log(response: response, data: data)
				if let httpURLResponse = response as? HTTPURLResponse {
					if !(200 ... 299 ~= httpURLResponse.statusCode) {
						var error = NetworkingError(errorCode: httpURLResponse.statusCode)
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
							error.jsonPayload = json
						}
						throw error
					}
				}
				return data
			}.mapError { error -> NetworkingError in
				NetworkingError(error: error)
			}.map { data -> (Data?, Progress) in
				(data, Progress())
			}.eraseToAnyPublisher()

		let progressPublisher2: AnyPublisher<(Data?, Progress), Error> = progressPublisher
			.map { progress -> (Data?, Progress) in
				(nil, progress)
			}.eraseToAnyPublisher()

		return Publishers.Merge(callPublisher, progressPublisher2)
			.receive(on: DispatchQueue.main).eraseToAnyPublisher()
	}

	public func publisher() -> AnyPublisher<Data, Error> {
		publisher(retryCount: maxRetryCount)
	}

	private func publisher(retryCount: Int) -> AnyPublisher<Data, Error> {
		guard let urlRequest = buildURLRequest() else {
			return Fail(error: NetworkingError.unableToParseRequest as Error)
				.eraseToAnyPublisher()
		}

		logger.logLevel = .debug
		logger.log(request: urlRequest)

		let config = sessionConfiguration
		let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
		return urlSession.dataTaskPublisher(for: urlRequest)
			.tryMap { (data: Data, response: URLResponse) -> Data in
				self.logger.log(response: response, data: data)
				if let httpURLResponse = response as? HTTPURLResponse {
					if !(200 ... 299 ~= httpURLResponse.statusCode) {
						var error = NetworkingError(errorCode: httpURLResponse.statusCode)
						if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
							error.jsonPayload = json
						}
						throw error
					}
				}
				return data
			}.tryCatch { [weak self, urlRequest] error -> AnyPublisher<Data, Error> in
				guard
					let self,
					retryCount > 1,
					let retryPublisher = requestRetrier?(urlRequest, error)
				else {
					throw error
				}
				return retryPublisher
					.flatMap { _ -> AnyPublisher<Data, Error> in
						self.publisher(retryCount: retryCount - 1)
					}
					.eraseToAnyPublisher()
			}.mapError { error -> NetworkingError in
				NetworkingError(error: error)
			}.receive(on: DispatchQueue.main).eraseToAnyPublisher()
	}

	func execute() async throws -> Data {
		guard let urlRequest = buildURLRequest() else {
			throw NetworkingError.unableToParseRequest
		}
		logger.logLevel = .debug
		logger.log(request: urlRequest)

		let config = sessionConfiguration
		let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
		let (data, response) = try await urlSession.data(for: urlRequest)
		logger.log(response: response, data: data)
		if let httpURLResponse = response as? HTTPURLResponse, !(200 ... 299 ~= httpURLResponse.statusCode) {
			var error = NetworkingError(errorCode: httpURLResponse.statusCode)
			if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
				error.jsonPayload = json
			}
			throw error
		}
		return data
	}

	private func getURLWithParams() -> String {
		let urlString = baseURL + route
		guard !params.isEmpty, let url = URL(string: urlString) else {
			return urlString
		}

		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			return urlString
		}

		urlComponents.queryItems = params.map { key, value in
			URLQueryItem(name: key, value: "\(value)")
		}

		let query = params.asPercentEncodedString()
		urlComponents.percentEncodedQuery = query

		return urlComponents.url?.absoluteString ?? urlString
	}

	func buildURLRequest() -> URLRequest? {
		var urlString = baseURL + route
		var token = retrieveTokenValueFromKeychain()

		if httpMethod == .get {
			urlString = getURLWithParams()
		}

		guard let url = URL(string: urlString) else {
			return nil
		}
		var request = URLRequest(url: url)

		if let token, !token.isEmpty {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}

		if httpMethod != .get, multipartData == nil {
			switch parameterEncoding {
			case .urlEncoded:
				request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			case .json:
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		}

		request.httpMethod = httpMethod.rawValue
		for (key, value) in headers {
			request.setValue(value, forHTTPHeaderField: key)
		}

		if let timeout {
			request.timeoutInterval = timeout
		}

		if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
			let headers = HTTPCookie.requestHeaderFields(with: cookies)
			for (name, value) in headers {
				request.setValue(value, forHTTPHeaderField: name)
			}
		}

		if httpMethod != .get, multipartData == nil {
			if let encodableBody {
				let jsonEncoder = JSONEncoder()
				do {
					let data = try jsonEncoder.encode(encodableBody)
					request.httpBody = data
				}
				catch {
					print(error)
				}
			}
			else {
				switch parameterEncoding {
				case .urlEncoded:
					request.httpBody = params.asPercentEncodedString().data(using: .utf8)
				case .json:
					let jsonData = try? JSONSerialization.data(withJSONObject: params)
					request.httpBody = jsonData
				}
			}
		}

		// Multipart
		if let multiparts = multipartData {
			// Construct a unique boundary to separate values
			let boundary = "Boundary-\(UUID().uuidString)"
			request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
			request.httpBody = buildMultipartHttpBody(params: params, multiparts: multiparts, boundary: boundary)
		}
		return request
	}

	private func buildMultipartHttpBody(params: Params, multiparts: [MultipartData], boundary: String) -> Data {
		// Combine all multiparts together
		let allMultiparts: [HttpBodyConvertible] = [params] + multiparts
		let boundaryEnding = "--\(boundary)--".data(using: .utf8)!

		// Convert multiparts to boundary-seperated Data and combine them
		return allMultiparts
			.map { (multipart: HttpBodyConvertible) -> Data in
				multipart.buildHttpBodyPart(boundary: boundary)
			}
			.reduce(Data(), +)
			+ boundaryEnding
	}

	public func urlSession(_: URLSession,
	                       task _: URLSessionTask,
	                       didSendBodyData _: Int64,
	                       totalBytesSent: Int64,
	                       totalBytesExpectedToSend: Int64)
	{
		let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
		progress.completedUnitCount = totalBytesSent
		progressPublisher.send(progress)
	}
}

extension CharacterSet {
	static let urlQueryValueAllowed: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@"
		let subDelimitersToEncode = "!$&'()*+,;="
		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}

public enum ParameterEncoding {
	case urlEncoded
	case json
}
