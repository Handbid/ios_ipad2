// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

public class NetworkingClient {
	public var defaultCollectionParsingKeyPath: String?
	let baseURL: String
	public var headers = [String: String]()
	public var parameterEncoding = ParameterEncoding.json
	public var timeout: TimeInterval?
	public var sessionConfiguration = URLSessionConfiguration.default
	public var requestRetrier: NetworkRequestRetrier?
	public var jsonDecoderFactory: (() -> JSONDecoder)?

	public var logLevel: NetworkingLogLevel {
		get { logger.logLevel }
		set { logger.logLevel = newValue }
	}

	private let logger = NetworkingLogger()

	// MARK: Properties - The init(timeout:) method initializes a NetworkingClient object with an optional timeout parameter.

	public init(timeout: TimeInterval? = nil) {
		self.baseURL = AppEnvironment.baseURL
		self.timeout = timeout
	}

	// MARK: Properties - The toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T method transforms JSON into a model object conforming to the NetworkingJSONDecodable protocol.

	public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T {
		do {
			let data = resourceData(from: json, keypath: keypath)
			return try T.decode(data)
		}
		catch {
			throw error
		}
	}

	// MARK: Properties - The toModel<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> T method transforms JSON into a model object conforming to the Decodable protocol.

	public func toModel<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> T {
		do {
			let jsonObject = resourceData(from: json, keypath: keypath)
			let decoder = jsonDecoderFactory?() ?? JSONDecoder()
			let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
			let model = try decoder.decode(T.self, from: data)
			return model
		}
		catch {
			throw error
		}
	}

	// MARK: Properties - The toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> [T] method transforms JSON into an array of model objects conforming to the NetworkingJSONDecodable protocol.

	public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
		do {
			guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
				return [T]()
			}
			return try array.map {
				try T.decode($0)
			}.compactMap { $0 }
		}
		catch {
			throw error
		}
	}

	// MARK: Properties - The toModels<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> [T] method transforms JSON into an array of model objects conforming to the Decodable protocol.

	public func toModels<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
		do {
			guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
				return [T]()
			}
			return try array.map { jsonObject in
				let decoder = jsonDecoderFactory?() ?? JSONDecoder()
				let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
				let model = try decoder.decode(T.self, from: data)
				return model
			}.compactMap { $0 }
		}
		catch {
			throw error
		}
	}

	// MARK: Properties - The private method resourceData(from: keypath:) returns data from JSON, considering the optional keypath parameter.

	private func resourceData(from json: Any, keypath: String?) -> Any {
		if let keypath, !keypath.isEmpty, let dic = json as? [String: Any], let val = dic[keypath] {
			return val is NSNull ? json : val
		}
		return json
	}
}
