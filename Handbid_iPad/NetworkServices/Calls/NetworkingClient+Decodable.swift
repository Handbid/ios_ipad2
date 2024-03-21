// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

public extension NetworkingClient {
	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		get(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		return get(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		post(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func post<T: Decodable>(_ route: String,
	                        body: Encodable,
	                        keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		post(route, body: body)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		return post(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		put(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		return put(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		patch(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func patch<T: Decodable>(_ route: String,
	                         body: Encodable,
	                         keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		patch(route, body: body)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		return patch(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		delete(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		return delete(route, params: params)
			.tryMap { json -> T in try self.toModel(json, keypath: keypath) }
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

public extension NetworkingClient {
	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T
	{
		let json: Any = try await get(route, params: params)
		let model: T = try toModel(json, keypath: keypath)
		return model
	}

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		let json: Any = try await get(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) async throws -> T
	{
		let json: Any = try await post(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        body: Encodable,
	                        keypath: String? = nil) async throws -> T
	{
		let json: Any = try await post(route, body: body)
		return try toModel(json, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) async throws -> T where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		let json: Any = try await post(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T
	{
		let json: Any = try await put(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		let json: Any = try await put(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) async throws -> T
	{
		let json: Any = try await patch(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) async throws -> T where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		let json: Any = try await patch(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         body: Encodable,
	                         keypath: String? = nil) async throws -> T
	{
		let json: Any = try await patch(route, body: body)
		return try toModel(json, keypath: keypath)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) async throws -> T
	{
		let json: Any = try await delete(route, params: params)
		return try toModel(json, keypath: keypath)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) async throws -> T where T: Collection
	{
		let keypath = keypath ?? defaultCollectionParsingKeyPath
		let json: Any = try await delete(route, params: params)
		return try toModel(json, keypath: keypath)
	}
}
