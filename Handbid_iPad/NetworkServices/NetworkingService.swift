// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

public protocol NetworkingService {
	var network: NetworkingClient { get }
}

public extension NetworkingService {
	// MARK: Properties - Data

	// This method is designed to fetch data from the network in Data format using a publisher AnyPublisher<Data, Error>. It means you're getting a publisher that emits Data or an Error.

	func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
		network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
		network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) -> AnyPublisher<Data, Error> {
		network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
		network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
		network.patch(route, params: params)
	}

	func patch(_ route: String, body: Encodable) -> AnyPublisher<Data, Error> {
		network.patch(route, body: body)
	}

	func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
		network.delete(route, params: params)
	}

	// MARK: Properties - Void

	// This method also fetches data from the network, but in this case, it doesn't return any data (Void). However, in case of an error, it still publishes an Error.

	func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) -> AnyPublisher<Void, Error> {
		network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		network.patch(route, params: params)
	}

	func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
		network.delete(route, params: params)
	}

	// MARK: Properties -

	// This method is quite generic as it returns data of type Any, indicating that it could be various types of data. It's useful when you're not certain about the type of data being returned. However, like the previous methods, it publishes an Error in case of failure

	func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) -> AnyPublisher<Any, Error> {
		network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		network.patch(route, params: params)
	}

	func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
		network.delete(route, params: params)
	}

	// MARK: Properties - Decodable

	// This method is generic and can fetch data from the network that can be decoded into a specific type T, conforming to the Decodable protocol. It publishes a publisher of type T or an Error

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.get(route, params: params, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.post(route, params: params, keypath: keypath)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.put(route, params: params, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.patch(route, params: params, keypath: keypath)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.delete(route, params: params, keypath: keypath)
	}

	// MARK: Properties - Array Decodable

	// Instead of a single element of type T, it returns an array of elements of type T

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		network.get(route, params: params, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		network.post(route, params: params, keypath: keypath)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		network.put(route, params: params, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		network.patch(route, params: params, keypath: keypath)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) -> AnyPublisher<T, Error> where T: Collection
	{
		network.delete(route, params: params, keypath: keypath)
	}

	// MARK: Properties - NetworkingJSONDecodable

	// This method requires the type T to conform to the NetworkingJSONDecodable protocol

	func get<T: NetworkingJSONDecodable>(_ route: String,
	                                     params: Params = Params(),
	                                     keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.get(route, params: params, keypath: keypath)
	}

	func post<T: NetworkingJSONDecodable>(_ route: String,
	                                      params: Params = Params(),
	                                      keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.post(route, params: params, keypath: keypath)
	}

	func put<T: NetworkingJSONDecodable>(_ route: String,
	                                     params: Params = Params(),
	                                     keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.put(route, params: params, keypath: keypath)
	}

	func patch<T: NetworkingJSONDecodable>(_ route: String,
	                                       params: Params = Params(),
	                                       keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.patch(route, params: params, keypath: keypath)
	}

	func delete<T: NetworkingJSONDecodable>(_ route: String,
	                                        params: Params = Params(),
	                                        keypath: String? = nil) -> AnyPublisher<T, Error>
	{
		network.delete(route, params: params, keypath: keypath)
	}

	// MARK: Properties - Array NetworkingJSONDecodable

	// Returns an array of elements of type T

	func get<T: NetworkingJSONDecodable>(_ route: String,
	                                     params: Params = Params(),
	                                     keypath: String? = nil) -> AnyPublisher<[T], Error>
	{
		network.get(route, params: params, keypath: keypath)
	}

	func post<T: NetworkingJSONDecodable>(_ route: String,
	                                      params: Params = Params(),
	                                      keypath: String? = nil) -> AnyPublisher<[T], Error>
	{
		network.post(route, params: params, keypath: keypath)
	}

	func put<T: NetworkingJSONDecodable>(_ route: String,
	                                     params: Params = Params(),
	                                     keypath: String? = nil) -> AnyPublisher<[T], Error>
	{
		network.put(route, params: params, keypath: keypath)
	}

	func patch<T: NetworkingJSONDecodable>(_ route: String,
	                                       params: Params = Params(),
	                                       keypath: String? = nil) -> AnyPublisher<[T], Error>
	{
		network.patch(route, params: params, keypath: keypath)
	}

	func delete<T: NetworkingJSONDecodable>(_ route: String,
	                                        params: Params = Params(),
	                                        keypath: String? = nil) -> AnyPublisher<[T], Error>
	{
		network.delete(route, params: params, keypath: keypath)
	}
}

// MARK: - Properties - ASYNC

public extension NetworkingService {
	// Data

	func get(_ route: String, params: Params = Params()) async throws -> Data {
		try await network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) async throws -> Data {
		try await network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) async throws -> Data {
		try await network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) async throws -> Data {
		try await network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) async throws -> Data {
		try await network.patch(route, params: params)
	}

	func delete(_ route: String, params: Params = Params()) async throws -> Data {
		try await network.delete(route, params: params)
	}

	// Void

	func get(_ route: String, params: Params = Params()) async throws {
		try await network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) async throws {
		try await network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) async throws {
		try await network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) async throws {
		try await network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) async throws {
		try await network.patch(route, params: params)
	}

	func delete(_ route: String, params: Params = Params()) async throws {
		try await network.delete(route, params: params)
	}

	// JSON

	func get(_ route: String, params: Params = Params()) async throws -> Any {
		try await network.get(route, params: params)
	}

	func post(_ route: String, params: Params = Params()) async throws -> Any {
		try await network.post(route, params: params)
	}

	func post(_ route: String, body: Encodable) async throws -> Any {
		try await network.post(route, body: body)
	}

	func put(_ route: String, params: Params = Params()) async throws -> Any {
		try await network.put(route, params: params)
	}

	func patch(_ route: String, params: Params = Params()) async throws -> Any {
		try await network.patch(route, params: params)
	}

	func delete(_ route: String, params: Params = Params()) async throws -> Any {
		try await network.delete(route, params: params)
	}

	// Decodable

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T
	{
		try await network.get(route, params: params, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) async throws -> T
	{
		try await network.post(route, params: params, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String, body: Encodable) async throws -> T {
		try await network.post(route, body: body)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T
	{
		try await network.put(route, params: params, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) async throws -> T
	{
		try await network.patch(route, params: params, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String, body: Encodable) async throws -> T {
		try await network.patch(route, body: body)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) async throws -> T
	{
		try await network.delete(route, params: params, keypath: keypath)
	}

	// Array Decodable

	func get<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T where T: Collection
	{
		try await network.get(route, params: params, keypath: keypath)
	}

	func post<T: Decodable>(_ route: String,
	                        params: Params = Params(),
	                        keypath: String? = nil) async throws -> T where T: Collection
	{
		try await network.post(route, params: params, keypath: keypath)
	}

	func put<T: Decodable>(_ route: String,
	                       params: Params = Params(),
	                       keypath: String? = nil) async throws -> T where T: Collection
	{
		try await network.put(route, params: params, keypath: keypath)
	}

	func patch<T: Decodable>(_ route: String,
	                         params: Params = Params(),
	                         keypath: String? = nil) async throws -> T where T: Collection
	{
		try await network.patch(route, params: params, keypath: keypath)
	}

	func delete<T: Decodable>(_ route: String,
	                          params: Params = Params(),
	                          keypath: String? = nil) async throws -> T where T: Collection
	{
		try await network.delete(route, params: params, keypath: keypath)
	}
}
