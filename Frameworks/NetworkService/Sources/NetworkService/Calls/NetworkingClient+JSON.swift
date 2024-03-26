// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

extension NetworkingClient {
	func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		get(route, params: params).toJSON()
	}

	func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		post(route, params: params).toJSON()
	}

	func post(_ route: String, body: Encodable) -> AnyPublisher<Any, Error> {
		post(route, body: body).toJSON()
	}

	func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		put(route, params: params).toJSON()
	}

	func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		patch(route, params: params).toJSON()
	}

	func patch(_ route: String, body: Encodable) -> AnyPublisher<Any, Error> {
		patch(route, body: body).toJSON()
	}

	func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		delete(route, params: params).toJSON()
	}
}

extension NetworkingClient {
	func get(_ route: String, params: Params = Params()) async throws -> Any {
		let req = request(.get, route, params: params)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func post(_ route: String, params: Params = Params()) async throws -> Any {
		let req = request(.post, route, params: params)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func post(_ route: String, body: Encodable) async throws -> Any {
		let req = request(.post, route, encodableBody: body)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func put(_ route: String, params: Params = Params()) async throws -> Any {
		let req = request(.put, route, params: params)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func patch(_ route: String, params: Params = Params()) async throws -> Any {
		let req = request(.patch, route, params: params)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func patch(_ route: String, body: Encodable) async throws -> Any {
		let req = request(.patch, route, encodableBody: body)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}

	func delete(_ route: String, params: Params = Params()) async throws -> Any {
		let req = request(.delete, route, params: params)
		let data = try await req.execute()
		return try JSONSerialization.jsonObject(with: data, options: [])
	}
}

// Data to JSON
extension Publisher where Output == Data {
	func toJSON() -> AnyPublisher<Any, Error> {
		tryMap { data -> Any in
			try JSONSerialization.jsonObject(with: data, options: [])
		}.eraseToAnyPublisher()
	}
}
