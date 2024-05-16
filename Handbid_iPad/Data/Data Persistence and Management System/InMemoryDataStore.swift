// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation

class InMemoryDataStore<Entity: Identifiable & Codable>: DataStoreProtocool where Entity.ID == String {
	private var entities: [String: Entity] = [:]
	private let updateSubject = PassthroughSubject<Entity, Never>()

	var updates: AnyPublisher<Entity, Never> {
		updateSubject.eraseToAnyPublisher()
	}

	func load(completion: @escaping (Result<[Entity], Error>) -> Void) {
		completion(.success(Array(entities.values)))
	}

	func save(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
		entities[entity.id] = entity
		updateSubject.send(entity)
		completion(.success(()))
	}

	func update(entity: Entity, completion: @escaping (Result<Void, Error>) -> Void) {
		if let _ = entities.updateValue(entity, forKey: entity.id) {
			updateSubject.send(entity)
			completion(.success(()))
		}
		else {
			completion(.failure(NSError(domain: "UpdateError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
		}
	}

	func delete(entityId: String, completion: @escaping (Result<Void, Error>) -> Void) {
		if let _ = entities.removeValue(forKey: entityId) {
			completion(.success(()))
		}
		else {
			completion(.failure(NSError(domain: "DeleteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Entity not found"])))
		}
	}
}
