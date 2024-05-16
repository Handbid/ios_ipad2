// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

protocol DataStoreProtocool {
	associatedtype Entity: Identifiable & Codable
	var updates: AnyPublisher<Entity, Never> { get }
	func load(completion: @escaping (Result<[Entity], Error>) -> Void)
	func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
	func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void)
	func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void)
}
