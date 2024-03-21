// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

public extension NetworkingClient {
	func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		get(route, params: params)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		post(route, params: params)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func post(_ route: String, body: Encodable) -> AnyPublisher<Void, Error> {
		post(route, body: body)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		put(route, params: params)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		patch(route, params: params)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func patch(_ route: String, body: Encodable) -> AnyPublisher<Void, Error> {
		patch(route, body: body)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}

	func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		delete(route, params: params)
			.map { (_: Data) in () }
			.eraseToAnyPublisher()
	}
}

public extension NetworkingClient {
	func get(_ route: String, params: Params = Params()) async throws {
		let req = request(.get, route, params: params)
		_ = try await req.execute()
	}

	func post(_ route: String, params: Params = Params()) async throws {
		let req = request(.post, route, params: params)
		_ = try await req.execute()
	}

	func post(_ route: String, body: Encodable) async throws {
		let req = request(.post, route, encodableBody: body)
		_ = try await req.execute()
	}

	func put(_ route: String, params: Params = Params()) async throws {
		let req = request(.put, route, params: params)
		_ = try await req.execute()
	}

	func patch(_ route: String, params: Params = Params()) async throws {
		let req = request(.patch, route, params: params)
		_ = try await req.execute()
	}

	func delete(_ route: String, params: Params = Params()) async throws {
		let req = request(.delete, route, params: params)
		_ = try await req.execute()
	}
}